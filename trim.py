def trim(s):
    ll = len(s)
    forwardIndex = 0
    backwardIndex = ll - 1

    while forwardIndex < ll and s[forwardIndex] == ' ':
        forwardIndex = forwardIndex + 1
    
    while backwardIndex >= forwardIndex and s[backwardIndex] == ' ':
        backwardIndex = backwardIndex - 1

    new = s[forwardIndex:backwardIndex+1]
    
    return new


print(trim('hello^zc       '))

