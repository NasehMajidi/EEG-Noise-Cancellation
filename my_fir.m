function [out_filter]=my_fir(input_signal,coef_vector)
    N=length(input_signal);
    N2=length(coef_vector);
    for n=1:N
        if n<N2
            u_matrix=flip([zeros(N2-n,1);input_signal(1:n)]);
        else
            u_matrix=flip(input_signal(n-N2+1:n));
        end
        out_filter(n)=coef_vector'*u_matrix;
    end
end
