function [system_output]=my_system(system_input,N,a)
 system_output(1)=a(1)*system_input(1);
 system_output(2)=a(1)*system_input(1)+a(2)*system_input(2);
for i=3:N
    system_output(i)=a(1)*system_input(i)+a(2)*system_input(i-1)+a(3)*system_input(i-2);
end
    system_output(N+1)=a(2)*system_input(N)+a(3)*system_input(N-1);
    system_output(N+2)=a(3)*system_input(N);
end
