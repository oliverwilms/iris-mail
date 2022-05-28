Class dc.iris.mail.EmbeddedPython
{

ClassMethod getProductionName() As %Status [ Language = python ]
{
    # import the iris module
    import iris
    myGref = iris.gref('^Ens.Runtime')
    pName = myGref["Name"]
    return pName
}

/// https://docs.intersystems.com/irisforhealthlatest/csp/docbook/DocBook.UI.Page.cls?KEY=AEPYTHON#AEPYTHON_runpython_method
ClassMethod Test() As %Status [ Language = python ]
{
    # print the members of the Fibonacci series that are less than 10
    print('Fibonacci series:')
    a, b = 0, 1
    while a < 10:
        print(a, end=' ')
        a, b = b, a + b

    # import the iris module and show the classes in this namespace
    import iris
    print('\nInterSystems IRIS classes in this namespace:')
    status = iris.cls('%SYSTEM.OBJ').ShowClasses()
    return status
}

}
