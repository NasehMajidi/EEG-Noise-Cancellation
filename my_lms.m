function [w,e,dhat]=my_lms(u,d,mu,Ncoef,w_in)  
N=length(u);
e=zeros(N,1);
dhat=zeros(N,1);
if nargin<5
    w=zeros(Ncoef,N+1);
else
    w=[w_in,zeros(Ncoef,N)];
    for n=1:N
        if n<Ncoef
            u_matrix=flip([zeros(Ncoef-n,1);u(1:n)]);
        else
            u_matrix=flip(u(n-Ncoef+1:n));
        end
        dhat(n)=w(:,n)'*u_matrix;
        e(n)=d(n)-dhat(n);
        w(:,n+1)=w(:,n)-2*(mu*conj(e(n)))*u_matrix;
    end
end