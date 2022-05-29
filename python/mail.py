def getProductionName():
  import iris
  gref = iris.gref('Ens.Runtime')
  pName = gref["Name"]
  return pName
