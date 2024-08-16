# use datetime package

import datetime

print("Todays date: ",datetime.date.today())
print("Timestamp is : ",datetime.datetime.now())

today = datetime.date.today()
print("Day:", today.day, "\nMonth:", today.month, "\nYear:",today.year)

print("------------------------------------------------------")
class person:
    def __init__(self,name, surname, birthdate, address, contact,email):
        self.name = name
        self.surname = surname
        self.birthdate = birthdate
        self.address = address
        self.contact = contact
        self.email = email

    def age(self):
        today = today = datetime.date.today()
        age = today.year - self.birthdate.year
        # typecasting to dateformat
        if today < datetime.date(today.year,self.birthdate.month,self.birthdate.day):
            age <-1
        if age < 0:
            print("Person in yet to born")
        return age
    
dayobj = person("Issac","Wilson",datetime.date(2000,4,1),'Kochi',"1234567891","issac@ust.com")
print(dayobj.age())


# FILE HANDLING
print("--------------------------------------")
print("-----FILE HANDLING--------------------")
print("--------------------------------------")
# open file in read mode
fileobj = open('newfile.txt')
print(fileobj.read())

fileobj = open('newfile.txt','r')
#open file in write mode
fileobj = open('newtextfile.txt','w')
# do write the input content in an empty file
fileobj.write("this is new content added to the new file.")
fileobj.close()
# open file in read and write mode(r+)
fileobj1 = open('newtextfile.txt','r+')
print(fileobj1.read())
print("reading again")
# seek(0) - position the file cursor at first position
fileobj1.seek(0) 
print(fileobj1.read())

fileobj1.write("\nThis is another content appended in the EOF.")
fileobj1.seek(0) 
print(fileobj1.read())



# 'w+' - open file in write and then read mode
fileobj2 = open('filename.txt','w+')
print(fileobj2.read())
fileobj2.write("\nwrite the content in the newfile.")
fileobj2.seek(0)
print(fileobj2.read())
fileobj2.close()



print("--------------------------------------")

with open('newtextfile.txt','r+') as fileobj3:
    data = fileobj3.readlines()
    for line in data:
        word = line.split()
        print(word)

print("                                       ")
print("************List Comprehension**************")
print("                                       ")

#list comprehension
list1 = [x**2 for x in range(1,11) if x % 2 ==0]
print(list1)

list2 = []
for x in range(1,11):
    if x%2 == 0:
        list2.append(x)

print(list2)


mark = [12,40,43,55,66,75,90,64]
result = lambda mark: ('fail' if mark < 40 else 'C+' if mark > 40 and 
                       mark <50 else 'B' if mark > 50 and mark <60 else 'B+' 
                       if mark > 60 and mark <70 else 'A' if mark > 70 and mark <80 else 'A+')
grade = [result(mark) for mark in mark]
print(grade)
