from sympy import symbols, Eq, sin, log, solve, lambdify
import math
from utils import *

#Data
x = symbols('x')



f_exp1 = log(x/4) + 4*sin(3*x)+1
f_exp2 = x**6 -5.5*x**5 + 6.18*x**4 + 18.54*x**3 - 56.9592*x**2 + 55.9872*x - 19.3156

f1 = lambdify(x, f_exp1, 'math')
f2 = lambdify(x, f_exp2, 'math')


def input_right_values(variable_type: type, msg: str):
    while True:
        raw = input(msg)
        try:
            value = variable_type(raw)
            return value
        except (ValueError, TypeError):
            print("wrong type!")





def call_all_mathods(f,a,b,E=1e-6):
    print("\nBorders: ["+str(a)+", "+str(b)+"]\t| E = "+str(E)+"")
    print("-------------------------------\\")
    method_half(a,b,f)
    method_hord(a,b,f)
    method_newton(a,b,f)
    method_easy_itteration(a,b,f)
    print("-------------------------------/")




def derivative_approx(f,x,h=1e-6):
    return (f(x + h) - f(x - h)) / (2*h)

def second_derivative_approx(f,x,h=1e-6):
    return (f(x + h) - 2*f(x) + f(x - h)) / (h*h)

def _basic_verify(f,l_border:float,r_border:float) -> bool :
    f_l_border = f(l_border)
    f_r_border = f(r_border)
    if f_l_border * f_r_border < 0:
        # нормальный отрезок – есть смена знака
        return True

    if f_l_border * f_r_border > 0:
        print("no root (or even amount of roots)")
        return False
    
    return True

@timer
def method_half (l_border : float, r_border : float, f, E=1e-6) :
    if (_basic_verify(f,l_border,r_border)) :
        count=0
        while True:
            count+=1
            center = (l_border + r_border) /2

            if(f(l_border)*f(center)>0):  
                l_border = center
            else :
                r_border = center
            if abs(r_border-l_border)<E:
                print("\n\tmethod_half:")
                print("left border: "+str(l_border))
                print("right border: "+str(r_border))
                print("iterations: " + str(count))
                break

@timer
def method_hord(l_border : float, r_border : float,f, E=1e-6):
    if (_basic_verify(f,l_border,r_border)) :
        count=0
        if(f(l_border)* second_derivative_approx(f,l_border)<0):
            x = l_border
            passive_border = r_border
        else:
            x = r_border
            passive_border = l_border

        while True:
            count+=1
            fx = f(x)
            fpass = f(passive_border)
            denom = fpass - fx

            if abs(denom) < 1e-14:
                print("\tmethod_hord: division by zero, stop (denominator ≈ 0)")
                break

            new_x = x - ((passive_border - x) * fx) / denom
            if(abs(f(x)- f(new_x))<= E
               or abs(f(new_x))<= E) :
                print("\tmethod_hord:")
                print("root ≈ "+str(new_x)+ "\niterations: " + str(count))
                break
            x=new_x


@timer
def method_newton(l_border : float, r_border : float,f, E=1e-6):
    if (_basic_verify(f,l_border,r_border)) :
        count=0
        center = (l_border+r_border)/2
        x=0
        if(derivative_approx(f,center) * second_derivative_approx(f,center) >0) :
            x=r_border
        else:
            x = l_border
        while True:
            count+=1
            new_x = x - (f(x))/derivative_approx(f,x)
            if(abs(new_x - x) <= E):
                print("\tmethod_newton:")
                print("root ≈ "+str(new_x)+ "\niterations: " + str(count))
                break
            x=new_x

@timer
def method_easy_itteration(l_border : float, r_border : float,f, E=1e-6):
    if (_basic_verify(f,l_border,r_border)) :
        x = (l_border+r_border)/2
        count=0

        d_l =derivative_approx(f,l_border)
        d_r =derivative_approx(f,r_border)

        unsigned_d_l = abs(d_l)
        unsigned_d_r = abs(d_r)
        Q = max(
            unsigned_d_l,
            unsigned_d_r
            )
        K = math.ceil(Q/2)


        if(Q == unsigned_d_l):
            if(d_l<0): K*=-1
        else:
            if(d_r<0): K*=-1
        while True :
            count+=1
            new_x = x - (f(x) / K)
            if(abs(new_x-x)<=E):
                print("\tmethod_easy_itteration:")
                print("root ≈ " + str(new_x) + "\niterations: " + str(count))
                break
            x = new_x
        


