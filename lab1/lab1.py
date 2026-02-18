from sympy import symbols, Eq, sin, log, solve, lambdify
import math

x = symbols('x')
#f_exp = log(x/4) + 4*sin(3*x)+1
f_exp = x**6 -5.5*x**5 + 6.18*x**4 + 18.54*x**3 - 56.9592*x**2 + 55.9872*x - 19.3156
f = lambdify(x, f_exp, 'math')

#borders
a=1.8
b=2.8


def derivative_approx(x, h=1e-6):
    return (f(x + h) - f(x - h)) / (2*h)

def second_derivative_approx(x, h=1e-6):
    return (f(x + h) - 2*f(x) + f(x - h)) / (h*h)


def method_half (l_border : float, r_border : float, E=1e-6) :
    f_l_border = f(l_border)
    f_r_border = f(r_border)
    if(f_l_border * f_r_border <0) :
        

        while True:
            center = (l_border + r_border) /2
            if(f(l_border)*f(center)>0):  
                l_border = center
            else :
                r_border = center
            if abs(r_border-l_border)<E:
                print("left border: "+str(l_border))
                print("right border: "+str(r_border))
                break

    elif(f_l_border * f_r_border >0) :
        print("no root (or even amount of roots)")
    else :
        print("root is " + str(l_border if f_l_border==0 else r_border)  )


def method_hord(l_border : float, r_border : float, E=1e-6):
    f_l_border = f(l_border)
    f_r_border = f(r_border)
    if(f_l_border * f_r_border <0) :

        if(f(l_border)* second_derivative_approx(l_border)<0):
            x = l_border
            passive_border = r_border
        else:
            x = r_border
            passive_border = l_border

        while True:
            new_x = x - ((passive_border - x)*f(x))/(f(passive_border)-f(x))
            if(abs(f(x)- f(new_x))<= E
               or abs(f(new_x))<= E) :
                print("root ≈ "+str(new_x))
                break
            x=new_x

    elif(f_l_border * f_r_border >0) :
        print("no root (or even amount of roots)")
    else :
        print("root is " + str(l_border if f_l_border==0 else r_border)  )

def method_newton(l_border : float, r_border : float, E=1e-6):
    f_l_border = f(l_border)
    f_r_border = f(r_border)
    if(f_l_border * f_r_border <0) :
        center = (l_border+r_border)/2
        x=0
        if(derivative_approx(center) * second_derivative_approx(center) >0) :
            x=r_border
        else:
            x = l_border
        while True:
            new_x = x - (f(x))/derivative_approx(x)
            if(abs(new_x - x) <= E):
                print("root ≈ "+str(new_x))
                break
            x=new_x
    elif(f_l_border * f_r_border >0) :
        print("no root (or even amount of roots)")
    else :
        print("root is " + str(l_border if f_l_border==0 else r_border)  )

def method_easy_itteration(l_border : float, r_border : float, E=1e-6):
    f_l_border = f(l_border)
    f_r_border = f(r_border)
    if(f_l_border * f_r_border <0) :
        x = (l_border+r_border)/2

        d_l =derivative_approx(l_border)
        d_r =derivative_approx(r_border)

        unsigned_d_l = abs(d_l)
        unsigned_d_r = abs(d_r)
        Q = max(
            unsigned_d_l,
            unsigned_d_r
            )
        K = math.ceil(Q/2)
        if(Q == unsigned_d_l):
            if(derivative_approx(d_l)<0): K*=-1
        else:
            if(derivative_approx(d_r)<0): K*=-1
        while True :
            new_x = x - (f(x) / K)
            if(abs(new_x-x)<=E):
                print("root ≈ " + str(new_x))
                break
            x = new_x
        

    elif(f_l_border * f_r_border >0) :
        print("no root (or even amount of roots)")
    else :
        print("root is " + str(l_border if f_l_border==0 else r_border)  )


method_half(a,b)
print()
method_hord(a,b)
method_newton(a,b)
method_easy_itteration(a,b)


