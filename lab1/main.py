from methods import call_all_mathods,f1,f2

if __name__ == "__main__" :

    #borders
    # a = input_right_values(float, "Input left border:")
    # b = input_right_values(float, "Input right border:")

    Data_func1 = [
        [1.051,2],
        [1.1,2.09],
        [3.142,4],
        [3.3,4.18]
    ]

    Data_func2 = [
        [-3,-1.5],
        [1.8,4]
    ]
    

    f=0
    Data = []
    while(True):

        print("Choose function:")
        print(" 1.\tlog(x/4) + 4*sin(3*x)+1")                                                      #[0.1, 5]
        print(" 2.\tx**6 -5.5*x**5 + 6.18*x**4 + 18.54*x**3 - 56.9592*x**2 + 55.9872*x - 19.3156") #[-3,  4]
        response = input()
        if response.isdigit():
            response = int(response)
            if (response in range(1,3)):
                
                match response:
                    case 1: 
                        f = f1
                        Data = Data_func1
                    case 2:
                        f = f2
                        Data = Data_func2

                break
    
    for borders in Data:
        call_all_mathods(f,borders[0],borders[1])
