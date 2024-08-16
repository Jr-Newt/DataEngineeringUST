#public, Protected and Private access modifiers

# _name - protected
# __ name - private


#PROTECTED
class Employee:
    _name = None
    _department = None

    #declare contructors
    def __init__(self, name, department):
        self._name = name
        self._department = department
    #protected method
    def _display(self):
        print("Employee Name: ", self._name)
        print("Employee Department: ", self._department)

class EmpDetail(Employee):
    def __init__(self, name, department):
        Employee.__init__(self, name, department)

    def displayDetails(self):
        self._display()

obj1 = EmpDetail("Issac","Tech")
obj1.displayDetails()

print("--------------------------------------------------------------")

#PRIVATE
print("PRIVATE ACCESS MODIFIER")
class Employee:
    __name = None
    __department = None

    #declare contructors
    def __init__(self, name, department):
        self.__name = name
        self.__department = department
    #protected method
    def _display(self):
        print("Employee Name: ", self.__name)
        print("Employee Department: ", self.__department)

class EmpDetail(Employee):
    def __init__(self, name, department):
        Employee.__init__(self, name, department)

    def displayDetails(self):
        self.__display()

obj1 = EmpDetail("Issac","Tech")
obj1.displayDetails()
