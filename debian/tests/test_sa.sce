function y=rastrigin(x)
  y = x(1)^2+x(2)^2-cos(12*x(1))-cos(18*x(2));
endfunction

x0          = [2 2];
Proba_start = 0.7;
It_Pre      = 100;
It_extern   = 100;
It_intern   = 1000;
x_test = neigh_func_default(x0);

T0 = compute_initial_temp(x0, rastrigin, Proba_start, It_Pre);

Log = %T;
[x_opt, f_opt, sa_mean_list, sa_var_list] = optim_sa(x0, rastrigin, It_extern, It_intern, T0, Log);

mprintf("optimal solution:\n"); disp(x_opt);
mprintf("value of the objective function = %f\n", f_opt);

t = 1:length(sa_mean_list);
plot(t,sa_mean_list,"r",t,sa_var_list,"g");

// Save the solution
print("sa_solution.txt", x_opt);
