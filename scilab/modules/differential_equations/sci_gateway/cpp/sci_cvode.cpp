//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021-2023 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v3.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#include "differential_equations_gw.hxx"
#include "sci_sundialsode.hpp"
#include "CVODEManager.hxx"

types::Function::ReturnValue sci_cvode(types::typed_list &in, types::optional_list &opt, int _iRetCount, types::typed_list &out)
{
    return sci_sundialsode<CVODEManager>(in, opt, _iRetCount, out);
}














