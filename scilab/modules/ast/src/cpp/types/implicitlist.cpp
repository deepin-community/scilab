/*
*  Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
*  Copyright (C) 2008-2008 - DIGITEO - Antoine ELIAS
*
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
*
*/
#include <sstream>
#include <math.h>
#include "double.hxx"
#include "polynom.hxx"
#include "implicitlist.hxx"
#include "int.hxx"
#include "configvariable.hxx"
#include "scilabWrite.hxx"
#include "type_traits.hxx"
#include "types_tools.hxx"
#include "numericconstants.hxx"
#include "doubleexp.hxx"

#ifndef NDEBUG
#include "inspector.hxx"
#endif

#include "tostring_common.hxx"

extern "C"
{
#include "core_math.h"
#include "elem_common.h"
#include "finite.h"
}

std::wstring printInLinePoly(types::SinglePoly* _pPoly, std::wstring _stVar);
std::wstring printDouble(types::Double* _pD);
long long convert_input(types::InternalType* _poIT);
unsigned long long convert_unsigned_input(types::InternalType* _poIT);

namespace types
{
ImplicitList::~ImplicitList()
{
    if (isDeletable() == true)
    {
        if (m_poStart)
        {
            m_poStart->DecreaseRef();
            m_poStart->killMe();
        }

        if (m_poStep)
        {
            m_poStep->DecreaseRef();
            m_poStep->killMe();
        }

        if (m_poEnd)
        {
            m_poEnd->DecreaseRef();
            m_poEnd->killMe();
        }
    }
#ifndef NDEBUG
    Inspector::removeItem(this);
#endif
}

ImplicitList::ImplicitList()
{
    m_iSize     = -1;
    m_eOutType  = ScilabGeneric;
    m_bComputed = false;
    m_poStart   = NULL;
    m_poStep    = NULL;
    m_poEnd     = NULL;
    m_pDblStart = NULL;
    m_pDblStep  = NULL;
    m_pDblEnd   = NULL;
    m_eStartType = ScilabNull;
    m_eStepType = ScilabNull;
    m_eEndType = ScilabNull;

#ifndef NDEBUG
    Inspector::addItem(this);
#endif
}

ImplicitList::ImplicitList(InternalType* _poStart, InternalType* _poStep, InternalType* _poEnd)
{
    m_iSize     = -1;
    m_eOutType  = ScilabGeneric;
    m_bComputed = false;
    m_poStart   = NULL;
    m_poStep    = NULL;
    m_poEnd     = NULL;
    m_pDblStart = NULL;
    m_pDblStep  = NULL;
    m_pDblEnd   = NULL;

    setStart(_poStart);
    setStep(_poStep);
    setEnd(_poEnd);

#ifndef NDEBUG
    Inspector::addItem(this);
#endif
}

ImplicitList* ImplicitList::clone()
{
    return new ImplicitList(m_poStart, m_poStep, m_poEnd);
}

InternalType::ScilabType ImplicitList::getStartType()
{
    return m_poStart->getType();
}

InternalType::ScilabType ImplicitList::getStepType()
{
    return m_poStep->getType();
}

InternalType::ScilabType ImplicitList::getEndType()
{
    return m_poEnd->getType();
}

void ImplicitList::setStart(InternalType *_poIT)
{
    if (m_poStart)
    {
        //clear previous value
        m_poStart->DecreaseRef();
        m_poStart->killMe();
        m_poStart = NULL;
    }

    m_poStart = _poIT;
    if (m_poStart != NULL)
    {
        m_poStart->IncreaseRef();
        m_eStartType = m_poStart->getType();
    }
    m_bComputed = false;
}

void ImplicitList::setStep(InternalType *_poIT)
{
    if (m_poStep)
    {
        //clear previous value
        m_poStep->DecreaseRef();
        m_poStep->killMe();
        m_poStep = NULL;
    }

    m_poStep = _poIT;
    if (m_poStep != NULL)
    {
        m_poStep->IncreaseRef();
        m_eStepType = m_poStep->getType();
    }
    m_bComputed = false;
}

void ImplicitList::setEnd(InternalType* _poIT)
{
    if (m_poEnd)
    {
        //clear previous value
        m_poEnd->DecreaseRef();
        m_poEnd->killMe();
        m_poEnd = NULL;
    }

    m_poEnd = _poIT;
    if (m_poEnd != NULL)
    {
        m_poEnd->IncreaseRef();
        m_eEndType = m_poEnd->getType();
    }
    m_bComputed = false;
}

bool ImplicitList::operator==(const InternalType& it)
{
    if (const_cast<InternalType &>(it).isImplicitList() == false)
    {
        return false;
    }

    ImplicitList* pIL = const_cast<InternalType &>(it).getAs<ImplicitList>();

    return *m_poStart == *pIL->getStart() &&  *m_poStep == *pIL->getStep() &&  *m_poEnd == *pIL->getEnd();
}

bool ImplicitList::operator!=(const InternalType& it)
{
    return !(*this == it);
}

bool ImplicitList::compute()
{
    if (m_bComputed == true)
    {
        return true;
    }

    m_iSize = -1;
    if (isComputable() == true)
    {
        m_iSize = 0;
        if (m_eOutType == ScilabDouble)
        {
            m_pDblStart = m_poStart->getAs<Double>();
            double dblStart	= m_pDblStart->get(0);

            m_pDblStep = m_poStep->getAs<Double>();
            double dblStep	= m_pDblStep->get(0);

            m_pDblEnd = m_poEnd->getAs<Double>();
            double dblEnd	= m_pDblEnd->get(0);
            // othe way to compute

            // nan value
            if (ISNAN(dblStart) || ISNAN(dblStep) || ISNAN(dblEnd))
            {
                m_iSize = -1;
                m_bComputed = true;
                return true;
            }

            // no finite values
            if ( finite(dblStart) == 0 || finite(dblStep) == 0 || finite(dblEnd) == 0)
            {
                if ((dblStep > 0 && dblStart < dblEnd) ||
                        (dblStep < 0 && dblStart > dblEnd))
                {
                    // return nan
                    m_iSize = -1;
                }
                // else return []

                m_bComputed = true;
                return true;
            }

            // step null
            if (dblStep == 0) // return []
            {
                m_bComputed = true;
                return true;
            }

            if ((dblEnd-dblStart)/dblStep > INT_MAX)
            {
                throw ast::InternalError(_W("Cannot allocate memory"));
            }

            double dblVal = dblStart; // temp value
            double dblEps = NumericConstants::eps;
            double dblPrec = 2 * std::max(fabs(dblStart), fabs(dblEnd)) * dblEps;

            while (dblStep * (dblVal - dblEnd) <= 0)
            {
                m_iSize++;
                dblVal = dblStart + m_iSize * dblStep;
            }

            if (fabs(dblVal - dblEnd) < dblPrec)
            {
                m_iSize++;
            }
        }
        else //m_eOutType == ScilabInt
        {
            if (m_eOutType == ScilabInt8 ||
                    m_eOutType == ScilabInt16 ||
                    m_eOutType == ScilabInt32 ||
                    m_eOutType == ScilabInt64)
            {
                //signed
                long long llStart   = convert_input(m_poStart);
                long long llStep    = convert_input(m_poStep);
                long long llEnd     = convert_input(m_poEnd);

                // step null
                if (llStep == 0) // return []
                {
                    m_bComputed = true;
                    return true;
                }
                m_iSize = std::max(0,static_cast<int>(floor( static_cast<double>((llEnd - llStart) /(llStep)) )) + 1);
            }
            else
            {
                //unsigned
                unsigned long long ullStart = convert_unsigned_input(m_poStart);
                unsigned long long ullStep	= convert_unsigned_input(m_poStep);
                unsigned long long ullEnd   = convert_unsigned_input(m_poEnd);

                // step null
                if (ullStep == 0) // return []
                {
                    m_bComputed = true;
                    return true;
                }
                m_iSize = std::max(0,static_cast<int>(floor( static_cast<double>((ullEnd - ullStart) /(ullStep)) )) + 1);
            }
        }
        m_bComputed = true;
        return true;
    }
    else
    {
        return false;
    }
}

bool ImplicitList::isComputable()
{
    if (m_eStartType != ScilabDouble && m_poStart->isInt() == false)
    {
        return false;
    }

    if (m_eStepType != ScilabDouble && m_poStep->isInt() == false)
    {
        return false;
    }

    if (m_eEndType != ScilabDouble && m_poEnd->isInt() == false)
    {
        return false;
    }

    //"compute" output type
    m_eOutType = ScilabGeneric; //not defined type
    if (m_poStart->isInt())
    {
        m_eOutType  = m_poStart->getType();
    }
    else if (m_poStep->isInt())
    {
        m_eOutType  = m_poStep->getType();
    }
    else if (m_poEnd->isInt())
    {
        m_eOutType  = m_poEnd->getType();
    }
    else
    {
        m_eOutType  = ScilabDouble;
    }

    return true;
}

bool ImplicitList::toString(std::wostringstream& ostr)
{
    ostr << L" ";
    if (m_eStartType == ScilabDouble)
    {
        Double *pD = m_poStart->getAs<Double>();
        ostr << printDouble(pD);
    }
    else //Polynom
    {
        Polynom* pMP = m_poStart->getAs<types::Polynom>();
        ostr << printInLinePoly(pMP->get(0), pMP->getVariableName());
    }

    ostr << L":";

    if (m_eStepType == ScilabDouble)
    {
        Double *pD = m_poStep->getAs<Double>();
        ostr << printDouble(pD);
    }
    else //Polynom
    {
        Polynom* pMP = m_poStep->getAs<types::Polynom>();
        ostr << printInLinePoly(pMP->get(0), pMP->getVariableName());
    }

    ostr << L":";

    if (m_eEndType == ScilabDouble)
    {
        Double *pD = m_poEnd->getAs<Double>();
        ostr << printDouble(pD);
    }
    else //Polynom
    {
        Polynom* pMP = m_poEnd->getAs<types::Polynom>();
        ostr << printInLinePoly(pMP->get(0), pMP->getVariableName());
    }
    ostr << std::endl;
    return true;
}

InternalType::ScilabType ImplicitList::getOutputType()
{
    return m_eOutType;
}

void ImplicitList::extractValueAsDouble(int _iOccur, Double* d)
{
    double dblStart = m_pDblStart->get(0);
    double dblStep = m_pDblStep->get(0);
    d->get()[0] = dblStart + _iOccur * dblStep;
}

template<typename T>
void ImplicitList::extractValueAsInteger(int _iOccur, T* val)
{

    val->get()[0] = static_cast<typename T::type>(convert_input(m_poStart)) +
                    _iOccur * static_cast<typename T::type>(convert_input(m_poStep));
}

template<typename T>
void ImplicitList::extractValueAsUnsignedInteger(int _iOccur, T* val)
{
    val->get()[0] = static_cast<typename T::type>(convert_unsigned_input(m_poStart)) +
                    _iOccur * static_cast<typename T::type>(convert_unsigned_input(m_poStep));
}

InternalType* ImplicitList::getInitalType()
{
    if (compute())
    {
        int iDims = 2;
        int piDms[2] = {1, 1};
        switch (m_eOutType)
        {
            case ScilabDouble:
                return new Double(iDims, piDms);
            case ScilabInt8:
                return new Int8(iDims, piDms);
            case ScilabInt16:
                return new Int16(iDims, piDms);
            case ScilabInt32:
                return new Int32(iDims, piDms);
            case ScilabInt64:
                return new Int64(iDims, piDms);
            case ScilabUInt8:
                return new UInt8(iDims, piDms);
            case ScilabUInt16:
                return new UInt16(iDims, piDms);
            case ScilabUInt32:
                return new UInt32(iDims, piDms);
            case ScilabUInt64:
                return new UInt64(iDims, piDms);
        }
    }

    return nullptr;
}

//extract single value in a InternalType
bool ImplicitList::extractValue(int _iOccur, InternalType* pIT)
{
    if (pIT && compute() && m_iSize >= _iOccur)
    {
        switch (m_eOutType)
        {
            case ScilabInt8:
                extractValueAsInteger(_iOccur, pIT->getAs<Int8>());
                break;
            case ScilabInt16:
                extractValueAsInteger(_iOccur, pIT->getAs<Int16>());
                break;
            case ScilabInt32:
                extractValueAsInteger(_iOccur, pIT->getAs<Int32>());
                break;
            case ScilabInt64:
                extractValueAsInteger(_iOccur, pIT->getAs<Int64>());
                break;
            case ScilabUInt8:
                extractValueAsUnsignedInteger(_iOccur, pIT->getAs<UInt8>());
                break;
            case ScilabUInt16:
                extractValueAsUnsignedInteger(_iOccur, pIT->getAs<UInt16>());
                break;
            case ScilabUInt32:
                extractValueAsUnsignedInteger(_iOccur, pIT->getAs<UInt32>());
                break;
            case ScilabUInt64:
                extractValueAsUnsignedInteger(_iOccur, pIT->getAs<UInt64>());
                break;
            case ScilabDouble:
                extractValueAsDouble(_iOccur, pIT->getAs<Double>());
                break;
        }
        return true;
    }

    return false;
}

//extract matrix in a Internaltype
InternalType* ImplicitList::extractFullMatrix()
{
    InternalType* pIT = NULL;
    if (compute())
    {
        if (getSize() == 0) // return []
        {
            pIT = Double::Empty();
        }
        else if (getSize() == -1) // return nan
        {
            unsigned long long raw = 0x7ff8000000000000;
            double not_a_number = *( double* )&raw;
            pIT = new Double(not_a_number);
        }
        else if (m_eOutType == ScilabDouble)
        {
            pIT = new Double(1, m_iSize);
            extractFullMatrix(pIT->getAs<Double>());
        }
        else if (m_eOutType == ScilabInt8)
        {
            pIT	= new Int8(1, m_iSize);
            extractFullMatrix(pIT->getAs<Int8>());
        }
        else if (m_eOutType == ScilabUInt8)
        {
            pIT	= new UInt8(1, m_iSize);
            extractFullMatrix(pIT->getAs<UInt8>());
        }
        else if (m_eOutType == ScilabInt16)
        {
            pIT	= new Int16(1, m_iSize);
            extractFullMatrix(pIT->getAs<Int16>());
        }
        else if (m_eOutType == ScilabUInt16)
        {
            pIT	= new UInt16(1, m_iSize);
            extractFullMatrix(pIT->getAs<UInt16>());
        }
        else if (m_eOutType == ScilabInt32)
        {
            pIT	= new Int32(1, m_iSize);
            extractFullMatrix(pIT->getAs<Int32>());
        }
        else if (m_eOutType == ScilabUInt32)
        {
            pIT	= new UInt32(1, m_iSize);
            extractFullMatrix(pIT->getAs<UInt32>());
        }
        else if (m_eOutType == ScilabInt64)
        {
            pIT	= new Int64(1, m_iSize);
            extractFullMatrix(pIT->getAs<Int64>());
        }
        else if (m_eOutType == ScilabUInt64)
        {
            pIT	= new UInt64(1, m_iSize);
            extractFullMatrix(pIT->getAs<UInt64>());
        }
    }
    return pIT;
}

void ImplicitList::extractFullMatrix(Double *_p)
{
    double dblStart = m_poStart->getAs<Double>()->get(0);
    double dblStep  = m_poStep->getAs<Double>()->get(0);

    double* p = _p->get();
    for (int i = 0 ; i < m_iSize ; i++)
    {
        p[i] = dblStart + i * dblStep;
    }
}

template<typename T>
void ImplicitList::extractFullMatrix(T *_pT)
{
    typename T::type tStart = static_cast<typename T::type>(convert_input(m_poStart));
    typename T::type tStep = static_cast<typename T::type>(convert_input(m_poStep));

    typename T::type* p = _pT->get();
    for (int i = 0 ; i < m_iSize ; i++)
    {
        p[i] = tStart + i * tStep;
    }
}

bool ImplicitList::transpose(InternalType *& out)
{
    if (compute())
    {
        Double * pIT = new Double(m_iSize, 1);
        out = pIT;
        extractFullMatrix(pIT);

        return true;
    }

    return false;
}

bool ImplicitList::neg(InternalType *& out)
{
    if (compute() && m_poStart->isDouble() && m_poStep->isDouble() && m_poEnd->isDouble())
    {
        out = new Bool(1, m_iSize);
        type_traits::neg(m_poStart->getAs<Double>()->get(0), m_poStep->getAs<Double>()->get(0), m_poEnd->getAs<Double>()->get(0), static_cast<Bool *>(out)->get());

        return true;
    }

    return false;
}

bool ImplicitList::invoke(typed_list & in, optional_list & /*opt*/, int /*_iRetCount*/, typed_list & out, const ast::Exp & e)
{
    if (in.size() == 0)
    {
        out.push_back(this);
    }
    else
    {
        InternalType * _out = extract(&in);
        if (!_out)
        {
            std::wostringstream os;
            os << _W("Invalid index.\n");
            throw ast::InternalError(os.str(), 999, e.getLocation());
        }
        out.push_back(_out);
    }

    return true;
}

InternalType* ImplicitList::extract(typed_list* _pArgs)
{
    int iDims = (int)_pArgs->size();
    typed_list pArg;
    InternalType* pOut = NULL;

    int* piMaxDim = new int[iDims];
    int* piCountDim = new int[iDims];

    //evaluate each argument and replace by appropriate value and compute the count of combinations
    int iSeqCount = checkIndexesArguments(this, _pArgs, &pArg, piMaxDim, piCountDim);
    if (iSeqCount == 0)
    {
        //free pArg content
        cleanIndexesArguments(_pArgs, &pArg);
        delete[] piMaxDim;
        delete[] piCountDim;
        return createEmptyDouble();
    }

    // computable
    if(compute())
    {
        if(iSeqCount == 1 && iDims == 1) // (0:9)(5)
        {
            int index = (int)pArg[0]->getAs<Double>()->get()[0] - 1;
            if(index < m_iSize)
            {
                pOut = getInitalType();
                if(extractValue(index, pOut) == false)
                {
                    pOut->killMe();
                    pOut = NULL;
                }
            }
        }
        else
        {
            // for more complex argument, expand the implicit list
            // to perform the extraction on a more common type.
            InternalType* pIT = extractFullMatrix();
            pOut = pIT->getAs<GenericType>()->extract(_pArgs);
            pIT->killMe();
        }
    }
    else if((piMaxDim[0] > 0 && piMaxDim[0] <= 3) && iSeqCount != -1)
    {
        // check dims indexes other than the first one
        // (1:$)(2,1) works but not (1:$)(1,2)
        bool bOk = true;
        for(int i = 1; i < iDims; i++)
        {
            if(pArg[i]->getAs<Double>()->get(0) != 1)
            {
                bOk = false;
                break;
            }
        }

        if(bOk)
        {
            std::vector<int> indexes;
            indexes.reserve(iSeqCount);
            bool isOutPoly = false;
            double* pDbl = pArg[0]->getAs<Double>()->get();
            for (int i = 0 ; i < iSeqCount ; i++)
            {
                indexes.push_back((int)pDbl[i] - 1);
            }

            std::vector<InternalType*> vect;
            for (int i = 0 ; i < iSeqCount ; i++)
            {
                switch (indexes[i])
                {
                    case 0 : // start
                        vect.push_back(getStart());
                        // pPoly->set(i, start);
                        break;
                    case 1 : // step
                        vect.push_back(getStep());
                        break;
                    case 2 : // end
                        vect.push_back(getEnd());
                        break;
                    default :
                        vect.clear();
                        break;
                }
            }

            Polynom* pPoly = nullptr;
            for(auto elem : vect)
            {
                if(elem->isPoly())
                {
                    // (0:$)(:) vs (0:$)(1:$)
                    int iRows = (*_pArgs)[0]->isColon() ? iSeqCount : 1;
                    int iCols = (*_pArgs)[0]->isColon() ? 1 : iSeqCount;
                    pPoly = new Polynom(L"$", iRows, iCols);
                    break;
                }
            }

            if(pPoly)
            {
                for (int i = 0 ; i < iSeqCount ; i++)
                {
                    if(vect[i]->isPoly())
                    {
                        pPoly->set(i, vect[i]->getAs<Polynom>()->get(0));
                    }
                    else
                    {
                        double* coef = nullptr;
                        SinglePoly* singlePoly = new SinglePoly(&coef, 0);
                        coef[0] = vect[i]->getAs<Double>()->get(0);
                        pPoly->set(i, singlePoly);
                        singlePoly->killMe();
                    }
                }

                pOut = pPoly;
            }
            else if(vect.empty() == false)
            {
                Double* pDbl = new Double(1, iSeqCount);
                for (int i = 0 ; i < iSeqCount ; i++)
                {
                    pDbl->set(i, vect[i]->getAs<Double>()->get(0));
                }

                pOut = pDbl;
            }
        }
    }

    //free pArg content
    cleanIndexesArguments(_pArgs, &pArg);

    delete[] piMaxDim;
    delete[] piCountDim;
    return pOut;
}

ast::Exp * ImplicitList::getExp(const Location & loc)
{
    return new ast::DoubleExp(loc, this);
}

bool ImplicitList::isTrue()
{
    // TODO : manage int & co
    if (m_poStart->isDouble() && m_poStep->isDouble() && m_poEnd->isDouble())
    {
        return type_traits::isTrue(m_poStart->getAs<Double>()->get(0), m_poStep->getAs<Double>()->get(0), m_poEnd->getAs<Double>()->get(0));
    }

    return false;
}

bool ImplicitList::getMemory(long long* _piSize, long long* _piSizePlusType)
{
    *_piSize = sizeof(ImplicitList);
    *_piSizePlusType = *_piSize;
    return true;
}

}

std::wstring printInLinePoly(types::SinglePoly* _pPoly, std::wstring _stVar)
{
    std::wostringstream ostr;
    double* pdblIn = _pPoly->get();
    for (int i = 0 ; i < _pPoly->getSize() ; i++)
    {

        if (pdblIn[i] != 0)
        {
            DoubleFormat df;
            getDoubleFormat(pdblIn[i], &df);
            df.bPrintPoint = ostr.str().size() != 0;
            df.bPrintPlusSign = true;
            df.bPrintOne = i == 0;
            df.bPaddSign = false;
            df.bPrintBlank = false;
            df.bPrintPlusSign = false;

            addDoubleValue(&ostr, pdblIn[i], &df);
            if (i != 0)
            {
                ostr << _stVar;
                if (i > 1)
                {
                    ostr << "^" << i;
                }
            }
        }
    }
    return ostr.str();
}

std::wstring printDouble(types::Double* _pD)
{
    std::wostringstream ostr;
    DoubleFormat df;
    getDoubleFormat(_pD->get(0), &df);
    df.bPrintPoint = false;
    df.bPaddSign = false;
    df.bPrintBlank = false;
    addDoubleValue(&ostr, _pD->get(0), &df);
    return ostr.str();
}

long long convert_input(types::InternalType* _poIT)
{
    switch (_poIT->getType())
    {
        case types::InternalType::ScilabDouble:
            return static_cast<long long>(_poIT->getAs<types::Double>()->get(0));
        case types::InternalType::ScilabInt8:
            return static_cast<long long>(_poIT->getAs<types::Int8>()->get(0));
        case types::InternalType::ScilabUInt8:
            return static_cast<long long>(_poIT->getAs<types::UInt8>()->get(0));
        case types::InternalType::ScilabInt16:
            return static_cast<long long>(_poIT->getAs<types::Int16>()->get(0));
        case types::InternalType::ScilabUInt16:
            return static_cast<long long>(_poIT->getAs<types::UInt16>()->get(0));
        case types::InternalType::ScilabInt32:
            return static_cast<long long>(_poIT->getAs<types::Int32>()->get(0));
        case types::InternalType::ScilabUInt32:
            return static_cast<long long>(_poIT->getAs<types::UInt32>()->get(0));
        case types::InternalType::ScilabInt64:
            return static_cast<long long>(_poIT->getAs<types::Int64>()->get(0));
        case types::InternalType::ScilabUInt64:
            return static_cast<long long>(_poIT->getAs<types::UInt64>()->get(0));
        default:
            return 0;
    }
    return 0;
}

unsigned long long convert_unsigned_input(types::InternalType* _poIT)
{
    switch (_poIT->getType())
    {
        case types::InternalType::ScilabDouble:
            return static_cast<unsigned long long>(_poIT->getAs<types::Double>()->get(0));
        case types::InternalType::ScilabInt8:
            return static_cast<unsigned long long>(_poIT->getAs<types::Int8>()->get(0));
        case types::InternalType::ScilabUInt8:
            return static_cast<unsigned long long>(_poIT->getAs<types::UInt8>()->get(0));
        case types::InternalType::ScilabInt16:
            return static_cast<unsigned long long>(_poIT->getAs<types::Int16>()->get(0));
        case types::InternalType::ScilabUInt16:
            return static_cast<unsigned long long>(_poIT->getAs<types::UInt16>()->get(0));
        case types::InternalType::ScilabInt32:
            return static_cast<unsigned long long>(_poIT->getAs<types::Int32>()->get(0));
        case types::InternalType::ScilabUInt32:
            return static_cast<unsigned long long>(_poIT->getAs<types::UInt32>()->get(0));
        case types::InternalType::ScilabInt64:
            return static_cast<unsigned long long>(_poIT->getAs<types::Int64>()->get(0));
        case types::InternalType::ScilabUInt64:
            return static_cast<unsigned long long>(_poIT->getAs<types::UInt64>()->get(0));
        default:
            return 0;
    }
    return 0;
}
