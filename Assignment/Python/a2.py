expense = []

class Expense():
    def __init__(self, expense_id, date, category, description, amount):
        self.expense_id = expense_id
        self.date = date
        self.category = category
        self.description = description
        self.amount = amount

    def __str__(self):
        return f"Expense: {self.expense_id}\nDate: {self.date}\nCategory: {self.category} Description{self.description} Amount: {self.amount}"  


def addexpense(new_expense):
    expense.append(new_expense)

def update_expense(expense_id,new_expense):
    for i, expens in enumerate(expense):
        if expens.expense_id == expense_id:
            expens = new_expense
            return True
    return False

def delete_expense(expense_id):
    for expens in expense:
        if expens.expense_id == expense_id:
            expense.remove(expens)
            return True
    return False
    # self.expenses.remove(expense_id)

def display_expense():
    for expens in expense:
        print(expens)
            

# user_db = {"issac":"***","anu":"qwerty","Elias":"pass123"}
# admin_db = {"admin":"pass123","admin1":"pass@123"}

users = {"issac":"pass123"}

def authenticate(username, password):
    if username in users:
        for user,pwd in users.items():
            if username==user and password==pwd:
                print("Login successful")
                return True
        print(" username or passowrd")
        return False
    else:
        print("invalid authentication")

def categorization():
    categories = {}
    for expens in expense:
        if expens.category in categories:
            categories[expens.category] += expens.amount
        else:
            categories[expens.category] = expens.amount
    return categories

def calculate_total_expense():
    return sum(expense.amount for expense in expense)

def generate_summary():
    categories = categorization()
    print("Expense Summary Report:")
    for category, amount in categories.items():
        print(f"{categories}: {amount:2f}")
    print(f"Total Expenses: {calculate_total_expense():}")


# authenticate("issac","pass123")

def cli():
    print("\n Expense Tracker Menu")
    print("1. Add a new expense")
    print("2. Update an existing expense")
    print("3. Delete an expense")
    print("4. Display all expenses")
    print("5. Generate summary report")
    print("6. Exit")

    choice = input("Enter your choice (1-6): ")

    if choice == '1':
        expense_id = input("enter expense ID:")
        date = input("enter the date (YYYY-MM-DD)")
        category = input("Enter category: ")
        description = input("Enter the description: ")
        amount = float(input("enter the amount: "))
        new_expense = Expense(expense_id, date, category, description, amount)
        addexpense(new_expense)
        print("Expense added successfully")
    
    elif choice == '2':
        expense_id = input("enter expense ID:")
        date = input("enter the date (YYYY-MM-DD)")
        category = input("Enter category: ")
        description = input("Enter the description: ")
        amount = float(input("enter the amount: "))
        new_expense = Expense(expense_id, date, category, description, amount)
        addexpense(new_expense)
        if update_expense(expense_id, new_expense):
            print("Expense updated successfully")
        else :
            print("Expense not found")

    elif choice =='3':
        expense_id = input("Enter expense ID to delete: ")
        if delete_expense(expense_id):
            print("Expense Deleted Successfully")
        else:
            print("Expense not found")

    elif choice == '4':
        display_expense()
    
    elif choice == '5':
        generate_summary()

    elif choice == '6':
        print("Exiting the program")
        return False
    
    else:
        print("Invalid choice, please try again")
    return True

def main():
    print("Welcome to the expense tracker")
    username = input("enter USername: ")
    password = input("Enter password: ")

    if authenticate(username,password):
        while cli():
            pass

main()


