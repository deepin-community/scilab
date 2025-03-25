/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2017 - ESI-Group - Cedric DELAMARRE
*
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

#include "webtools_gw.hxx"
#include "function.hxx"
#include "string.hxx"
#include "double.hxx"
#include "struct.hxx"
#include "json.hxx"

extern "C"
{
#include "localization.h"
#include "Scierror.h"
#include "sciprint.h"
#include "sci_malloc.h"
#include "getFullFilename.h"
}

static void cleanup(std::vector<char*> files);
/*--------------------------------------------------------------------------*/
static const char fname[] = "http_upload";
types::Function::ReturnValue sci_http_upload(types::typed_list &in, types::optional_list &opt, int _iRetCount, types::typed_list &out)
{
    if (in.size() < 3 || in.size() > 4)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d to %d expected.\n"), fname, 3, 4);
        return types::Function::Error;
    }

    if (_iRetCount > 3)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d to %d expected.\n"), fname, 1, 3);
        return types::Function::Error;
    }

    // get URL
    if(in[0]->isString() == false || in[0]->getAs<types::String>()->isScalar() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A scalar string expected.\n"), fname, 1);
        return types::Function::Error;
    }

    // get input file name
    if(in[1]->isString() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A matrix string expected.\n"), fname, 2);
        return types::Function::Error;
    }

    types::String* pStrFiles = in[1]->getAs<types::String>();
    std::vector<char*> files;
    for(int i = 0; i < pStrFiles->getSize(); i++)
    {
        wchar_t* pwcFileName = getFullFilenameW(pStrFiles->get(i));
        files.push_back(wide_string_to_UTF8(pwcFileName));
        FREE(pwcFileName);
    }

    // get variable name server side
    if(in[2]->isString() == false || in[2]->getAs<types::String>()->isScalar() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A scalar string expected.\n"), fname, 3);
        cleanup(files);
        return types::Function::Error;
    }

    SciCurl query;
    if(query.init() == false)
    {
        Scierror(999, _("%s: CURL initialization failed.\n"), fname);
        cleanup(files);
        return types::Function::Error;
    }

    if(setPreferences(query, fname))
    {
        return types::Function::Error;
    }

    char* pcURL = wide_string_to_UTF8(in[0]->getAs<types::String>()->get(0));
    query.setURL(pcURL);
    FREE(pcURL);

    // common optional argument
    if(checkCommonOpt(query, opt, fname))
    {
        return types::Function::Error;
    }

    if(in.size() > 3)
    {
        // get data
        if(in[3]->isStruct() == false || in[3]->getAs<types::Struct>()->isScalar() == false)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: A structure of size %d expected.\n"), fname, 4, 1);
            return types::Function::Error;
        }

        types::Struct* pStruct = in[3]->getAs<types::Struct>();
        std::unordered_map<std::wstring, int> fieldsMap = pStruct->get(0)->getFields();
        std::vector<types::InternalType*> pITData = pStruct->get(0)->getData();
        for (const auto & field : fieldsMap)
        {
            char* pcFieldName = wide_string_to_UTF8(field.first.data());
            std::string strData(toJSON(pITData[field.second]));
            //remove " @start and @end of string
            if (strData.front() == '\"' && strData.back() == '\"')
            {
                strData = strData.substr(1);
                strData.pop_back();
            }

            query.addContentToForm(pcFieldName, strData.data());
            FREE(pcFieldName);
        }
    }

    // Add file to form after data in case data contents is mandatory for file upload (identifier, ticket, ...)
    char* pcVarName = wide_string_to_UTF8(in[2]->getAs<types::String>()->get(0));
    for (auto f : files)
    {
        query.addFileToForm(pcVarName, f);
    }
    FREE(pcVarName);
    cleanup(files);

    // specific optional argument
    for (const auto& o : opt)
    {
        if (o.first == L"method")
        {
            if(o.second->isString() == false || o.second->getAs<types::String>()->isScalar() == false)
            {
                Scierror(999, _("%s: Wrong type for input argument #%s: A scalar string expected.\n"), fname, "method");
                return types::Function::Error;
            }

            wchar_t* pMeth = o.second->getAs<types::String>()->get(0);
            if(wcscmp(pMeth, L"PUT") == 0)
            {
                query.setMethod("PUT");
            }
            else if(wcscmp(pMeth, L"POST") == 0)
            {
                query.setMethod("POST");
            }
            else
            {
                Scierror(999, _("%s: Wrong value for input argument #%s: 'PUT' or 'POST' expected.\n"), fname, "method");
                return types::Function::Error;
            }
        }
    }

    // configure headers when they have all been added.
    query.setHTTPHeader();
    // configure the form when it have been filled.
    query.setForm();

    // send the query
    query.perform();
    if(query.hasFailed())
    {
        Scierror(999, _("%s: CURL execution failed.\n%s\n"), fname, query.getError());
        return types::Function::Error;
    }

    if(query.hasFailed())
    {
        Scierror(999, _("%s: CURL execution failed.\n%s\n"), fname, query.getError());
        return types::Function::Error;
    }

    out.push_back(query.getResult());
    if(_iRetCount > 1)
    {
        out.push_back(new types::Double((double)query.getResponseCode()));
    }

    if(_iRetCount > 2)
    {
        out.push_back(query.getHeaders());
    }

    return types::Function::OK;
}


static void cleanup(std::vector<char*> files)
{
    for(auto& file : files)
    {
        FREE(file);
    }
}