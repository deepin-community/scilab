// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - 3DS - Cédric DELAMARRE
//
// <-- Non-regression test for bug 17083 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17083
//
// <-- Short Description -->
// sci2exp, bad management of lmax in mat2exp and str2exp

// str2exp
exp = sci2exp("123456789", 5);
assert_checkequal(exp, """123456789""");

// mat2exp
graphics = mlist(["graphics","orig","sz","exprs","pin","pout","pein","peout","gr_i","id","in_implicit","out_implicit","in_style","out_style","in_label","out_label","style"],[800.16967,410.0631],[40,60],["1";"[1;1;1;1;1]"],[93;99;104;109;145],148,[],[],[],"",["E";"E";"E";"E";"E"],"E",["ExplicitInputPort;rotation=0;flip=false;mirror=false;align=left;verticalAlign=middle;spacing=10.0";"ExplicitInputPort;rotation=0;flip=false;mirror=false;align=left;verticalAlign=middle;spacing=10.0";"ExplicitInputPort;rotation=0;flip=false;mirror=false;align=left;verticalAlign=middle;spacing=10.0";"ExplicitInputPort;rotation=0;flip=false;mirror=false;align=left;verticalAlign=middle;spacing=10.0";"ExplicitInputPort;rotation=0;flip=false;mirror=false;align=left;verticalAlign=middle;spacing=10.0"],"ExplicitOutputPort;rotation=0;flip=false;mirror=false;align=right;verticalAlign=middle;spacing=10.0",["";"";"";"";""],"","MATCATH;rotation=0;flip=false;mirror=false");
exp = sci2exp(graphics, 80);
assert_checkequal(find(exp == ""), []);

// should not produce warnings
sci2exp(graphics, 10);
