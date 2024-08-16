import random

print("Welcome to the Demo Marketplace")

# User and admin databases
user_db = {"user1": "pass1", "user2": "pass2"}
admin_db = {"admin1": "adminpass1", "admin2": "adminpass2"}

# Product catalog
catalog = [
    {"id": 1, "name": "Boots", "category": "Footwear", "price": 99.99},
    {"id": 2, "name": "Coat", "category": "Clothing", "price": 149.99},
    {"id": 3, "name": "Jacket", "category": "Clothing", "price": 79.99},
    {"id": 4, "name": "Cap", "category": "Accessories", "price": 24.99},
]

cart = []

def generate_session_id():
    return str(random.randint(10000, 99999))

def login(is_admin=False):
    username = input("Enter username: ")
    password = input("Enter password: ")
    db = admin_db if is_admin else user_db
    if username in db and db[username] == password:
        print(f"Login successful as {'admin' if is_admin else 'user'}")
        return username, generate_session_id()
    else:
        print("Login failed")
        return None, None

def display_catalog():
    print("\nProduct Catalog:")
    for product in catalog:
        print(f"ID: {product['id']}, Name: {product['name']}, Category: {product['category']}, Price: ${product['price']}")

# def display_cart():
#     if not cart:
#         print("Your cart is empty.")
#     else:
#         print("\nYour Cart:")
#         total = 0
#         for item in cart:
#             product = next(p for p in catalog if p['id'] == item['product_id'])
#             price = product['price'] * item['quantity']
#             total += price
#             print(f"Product: {product['name']}, Quantity: {item['quantity']}, Price: ${price}")
#         print(f"Total: ${total}")

def display_cart():
    if not cart:
        print("Your cart is empty.")
    else:
        print("\nYour Cart:")
        total = 0
        for item in cart:
            product = None

            for p in catalog:
                if p['id'] == item['product_id']:
                    product = p
                    break

            price = product['price'] * item['quantity']
            total += price
            print(f"Product: {product['name']}, Quantity: {item['quantity']}, Price: ${price}")
        print(f"Total: ${total}")


def add_to_cart(product_id, quantity):
    product = next((p for p in catalog if p['id'] == product_id), None)
    if product:
        cart.append({"product_id": product_id, "quantity": quantity})
        print(f"Added {quantity} {product['name']}(s) to cart.")
    else:
        print("Product not found.")

def remove_from_cart(product_id):
    for item in cart:
        if item['product_id'] == product_id:
            cart.remove(item)
            print("Item removed from cart.")
            return
    print("Item not found in cart.")

def checkout():
    payment_method = input("Select payment method (1. Net banking, 2. PayPal): ")
    # total = sum(next(p for p in catalog if p['id'] == item['product_id'])['price'] * item['quantity'] for item in cart)
    prices = []
    for item in cart:
        product = next(p for p in catalog if p['id'] == item['product_id'])
        price = product['price']
        total = price * item['quantity']
        prices.append(total)

    print(f"Your order is successfully placed. Total amount: ${total}")
    print(f"You will be shortly redirected to the portal to make a payment of ${total}")
    cart.clear()

def add_product():
    product_id = int(input("Enter product ID: "))
    name = input("Enter product name: ")
    category = input("Enter product category: ")
    price = float(input("Enter product price: "))
    catalog.append({"id": product_id, "name": name, "category": category, "price": price})
    print("Product added successfully.")

def update_product():
    product_id = int(input("Enter product ID to update: "))
    for product in catalog:
        if product['id'] == product_id:
            product['name'] = input("Enter new name: ")
            product['category'] = input("Enter new category: ")
            product['price'] = float(input("Enter new price: "))
            print("Product updated successfully.")
            return
    print("Product not found.")

def remove_product():
    product_id = int(input("Enter product ID to remove: "))
    for product in catalog:
        if product['id'] == product_id:
            catalog.remove(product)
            print("Product removed successfully.")
            return
    print("Product not found.")

def main():
    while True:
        user_type = input("Login as (1) User or (2) Admin? ")
        username, session_id = login(user_type == "2")
        if username:
            print(f"Session ID: {session_id}")
            break

    if user_type == "1":  # User
        while True:
            action = input("\nChoose action:\n1. View catalog\n2. View cart\n3. Add to cart\n4. Remove from cart\n5. Checkout\n6. Logout\nEnter choice: ")
            if action == "1":
                display_catalog()
            elif action == "2":
                display_cart()
            elif action == "3":
                product_id = int(input("Enter product ID: "))
                quantity = int(input("Enter quantity: "))
                add_to_cart(product_id, quantity)
            elif action == "4":
                product_id = int(input("Enter product ID to remove: "))
                remove_from_cart(product_id)
            elif action == "5":
                checkout()
            elif action == "6":
                print("Logged out successfully.")
                break
            else:
                print("Invalid choice. Please try again.")
    else:  # Admin
        while True:
            action = input("\nChoose action:\n1. View catalog\n2. Add product\n3. Update product\n4. Remove product\n5. Logout\nEnter choice: ")
            if action == "1":
                display_catalog()
            elif action == "2":
                add_product()
            elif action == "3":
                update_product()
            elif action == "4":
                remove_product()
            elif action == "5":
                print("Logged out successfully.")
                break
            else:
                print("Invalid choice. Please try again.")

main()