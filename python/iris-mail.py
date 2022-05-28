def getProductionName():
  myGref = iris.gref('Ens.Runtime')
  pName = myGref["Name"]
  return pName
