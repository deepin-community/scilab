/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2017 - ESI-Group - Cedric DELAMARRE
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

extern "C"
{
#include "localization.h"
#include "Scierror.h"
}

/*--------------------------------------------------------------------------*/
int setPreferences(SciCurl& query, const char* fname)
{
    // set proxy information
    if(query.setProxy() == false)
    {
        Scierror(999, _("%s: Wrong proxy information, please check in the '%s' Scilab preference.\n"), fname, _("Web"));
        return 1;
    }    

    // set cookies information
    if(query.setCookies() == false)
    {
        Scierror(999, _("%s: Wrong cookies information, please check in the '%s' Scilab preference.\n"), fname, _("Web"));
        return 1;
    }

    return 0;
}
