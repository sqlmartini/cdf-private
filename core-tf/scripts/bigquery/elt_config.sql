CREATE TABLE `amm-elt-demo.adventureworks.elt_config`
(
  sourceTableName STRING,
  targetTableName STRING
)

INSERT INTO `amm-elt-demo.adventureworks.elt_config`
VALUES 
  ('Sales.SalesOrderHeader', 'SalesOrderHeader'), 
  ('Sales.SalesOrderDetail', 'SalesOrderDetail'),
  ('Sales.SalesTerritory', 'SalesTerritory'),
  ('Production.Product', 'Product'),
  ('Production.ProductCategory', 'ProductCategory')
  ('Production.ProductSubcategory', 'ProductSubcategory')