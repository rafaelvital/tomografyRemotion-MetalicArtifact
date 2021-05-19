function B = takeline( A )
% Usato per prendera la linea al analisare la imagine Phanton Hip
% p1  230 60
% p2  280 260
% p3  200 370

x = linspace(230,280,100);
x = [x linspace(280,200,100)];

y = linspace(60,260,100);
y = [y linspace(260,370,100)];

x = round(x);
y = round(y);

B = zeros(1,200);

for i=1:200;
    B(i) = A(x(i),y(i));
end
end

