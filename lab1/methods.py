from sympy import symbols, Eq, sin, log, solve, lambdify
import math

def input_right_values(variable_type: type, msg: str):
    while True:
        raw = input(msg)
        try:
            value = variable_type(raw)
            return value
        except (ValueError, TypeError):
            print("wrong type!")



x = symbols('x')
f_exp = log(x/4) + 4*sin(3*x)+1
#f_exp = x**6 -5.5*x**5 + 6.18*x**4 + 18.54*x**3 - 56.9592*x**2 + 55.9872*x - 19.3156
f = lambdify(x, f_exp, 'math')


print("For function: " + str(f_exp))

#borders
a = input_right_values(float, "Input left border:")
b = input_right_values(float, "Input right border:")


def derivative_approx(x,h=1e-6):
    return (f(x + h) - f(x - h)) / (2*h)

def second_derivative_approx(x,h=1e-6):
    return (f(x + h) - 2*f(x) + f(x - h)) / (h*h)

def basic_verify(l_border:float,r_border:float) -> bool :
    f_l_border = f(l_border)
    f_r_border = f(r_border)
    if(f_l_border * f_r_border <0) : return True
    elif(f_l_border * f_r_border >0) : 
        print("no root (or even amount of roots)")
        return False
    else:
        print("root is " + str(l_border if f_l_border==0 else r_border) )
        return False


def method_half (l_border : float, r_border : float, E=1e-6) :
    if (basic_verify(l_border,r_border)) :
        count=0
        while True:
            count+=1
            center = (l_border + r_border) /2

            if(f(l_border)*f(center)>0):  
                l_border = center
            else :
                r_border = center
            if abs(r_border-l_border)<E:
                print("left border: "+str(l_border))
                print("right border: "+str(r_border))
                print("iterations: " + str(count))
                print()
                break


def method_hord(l_border : float, r_border : float, E=1e-6):
    if (basic_verify(l_border,r_border)) :
        count=0
        if(f(l_border)* second_derivative_approx(l_border)<0):
            x = l_border
            passive_border = r_border
        else:
            x = r_border
            passive_border = l_border

        while True:
            count+=1
            new_x = x - ((passive_border - x)*f(x))/(f(passive_border)-f(x))
            if(abs(f(x)- f(new_x))<= E
               or abs(f(new_x))<= E) :
                print("root ≈ "+str(new_x)+ "\niterations: " + str(count))
                break
            x=new_x



def method_newton(l_border : float, r_border : float, E=1e-6):
    if (basic_verify(l_border,r_border)) :
        count=0
        center = (l_border+r_border)/2
        x=0
        if(derivative_approx(center) * second_derivative_approx(center) >0) :
            x=r_border
        else:
            x = l_border
        while True:
            count+=1
            new_x = x - (f(x))/derivative_approx(x)
            if(abs(new_x - x) <= E):
                print("root ≈ "+str(new_x)+ "\niterations: " + str(count))
                break
            x=new_x

def method_easy_itteration(l_border : float, r_border : float, E=1e-6):
    if (basic_verify(l_border,r_border)) :
        x = (l_border+r_border)/2
        count=0

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
            count+=1
            new_x = x - (f(x) / K)
            if(abs(new_x-x)<=E):
                print("root ≈ " + str(new_x) + "\niterations: " + str(count))
                break
            x = new_x
        


