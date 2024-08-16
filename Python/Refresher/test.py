#create a login access using loop and condition statement
while True:
    choice = input("choose an option")
    if choice == "login":
        user = input("enter user name: ")
        password = input("Enter user password: ")
        if user =='admin' and password =='pass@word':
            print("Login Successful. Welcome")
        else:
            print("Incorrect username or password, try Again")

    elif choice == 'quit':
        print("Exiting from the portal")
        break

    else:
        print("invalid choice")
