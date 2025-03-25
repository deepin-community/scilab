/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2013 - Scilab Enterprises - Cedric Delamarre
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
/*--------------------------------------------------------------------------*/
#include "completion_gw.hxx"
#include "function.hxx"
#include "string.hxx"
#include "double.hxx"
#include <map>
#include <functional>

extern "C"
{
#include "sci_malloc.h"
#include "localization.h"
#include "completion.h"
#include "Scierror.h"
#include "toolsdictionary.h"
}

std::map<std::wstring, std::function<char**(const char* somechars, int* sizeArrayReturned)>> helpers = 
{
    {L"functions", completionOnFunctions},
    {L"commands", completionOnCommandWords},
    {L"variables", completionOnVariables},
    {L"macros", completionOnMacros},
    {L"graphic_properties", completionOnHandleGraphicsProperties},
    {L"files", completionOnFiles},
    {L"mustBe", completionOnMustBe}
};

/*--------------------------------------------------------------------------*/
static types::InternalType* doCompletion(const char*, std::function<char**(const char* somechars, int* sizeArrayReturned)>);
/*--------------------------------------------------------------------------*/
types::Function::ReturnValue sci_completion(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    types::String* pStrSomechars = NULL;
    char* pcSomechars = NULL;

    if (in.size() < 1 || in.size() > 2)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d to %d expected."), "completion", 1, 2);
        return types::Function::Error;
    }

    if (_iRetCount > 6)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d to %d expected."), "completion", 1, 6);
        return types::Function::Error;
    }

    if (in[0]->isString() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: String expected.\n"), "completion", 1);
        return types::Function::Error;
    }

    pStrSomechars = in[0]->getAs<types::String>();

    if (pStrSomechars->isScalar() == false)
    {
        Scierror(999, _("%s: Wrong size for input argument #%d: string expected.\n"), "completion", 1);
        return types::Function::Error;
    }

    pcSomechars = wide_string_to_UTF8(pStrSomechars->get(0));

    if (in.size() == 1)
    {
        if (_iRetCount <= 1)
        {
            out.push_back(doCompletion(pcSomechars, &completion));
        }
        else
        {
            out.resize(_iRetCount);
            switch (_iRetCount)
            {
                case 6 :
                    out[5] = doCompletion(pcSomechars, &completionOnFiles);
                case 5 :
                    out[4] = doCompletion(pcSomechars, &completionOnHandleGraphicsProperties);
                case 4 :
                    out[3] = doCompletion(pcSomechars, &completionOnMacros);
                case 3 :
                    out[2] = doCompletion(pcSomechars, &completionOnVariables);
                case 2 :
                    out[1] = doCompletion(pcSomechars, &completionOnCommandWords);
                default :
                    out[0] = doCompletion(pcSomechars, &completionOnFunctions);
            }
        }
    }
    else // if(in.size() == 2)
    {
        if (_iRetCount > 1)
        {
            Scierror(78, _("%s: Wrong number of output argument(s): %d expected."), "completion", 1);
            FREE(pcSomechars);
            return types::Function::Error;
        }

        if (in[1]->isString() == false)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: String expected.\n"), "completion", 2);
            FREE(pcSomechars);
            return types::Function::Error;
        }

        types::String* pStrDictionary = in[1]->getAs<types::String>();

        if (pStrDictionary->isScalar() == false)
        {
            Scierror(999, _("%s: Wrong size for input argument #%d: string expected.\n"), "completion", 2);
            FREE(pcSomechars);
            return types::Function::Error;
        }

        wchar_t* wcsDictionary = pStrDictionary->get(0);
        if (helpers.find(wcsDictionary) != helpers.end())
        {
            out.push_back(doCompletion(pcSomechars, helpers[wcsDictionary]));
        }
        else
        {
            Scierror(999, _("%s: Wrong value for input argument: %s expected.\n"), "completion", 
                     "'functions', 'commands', 'variables', 'macros', 'graphic_properties', 'files' or 'mustBe'");
            FREE(pcSomechars);
            return types::Function::Error;
        }
    }

    FREE(pcSomechars);
    return types::Function::OK;
}
/*--------------------------------------------------------------------------*/
static types::InternalType* doCompletion(const char* _pcSomechars, std::function<char**(const char* somechars, int* sizeArrayReturned)> func)
{
    char** pstrResults  = NULL;
    int iSizeResults    = 0;

    pstrResults = func(_pcSomechars, &iSizeResults);

    if (iSizeResults)
    {
        types::String* pStrOut = new types::String(iSizeResults, 1);
        pStrOut->set(pstrResults);
        freePointerDictionary(pstrResults, iSizeResults);
        return pStrOut;
    }
    else
    {
        return types::Double::Empty();
    }
}
/*--------------------------------------------------------------------------*/
