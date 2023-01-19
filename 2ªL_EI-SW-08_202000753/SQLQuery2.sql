/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto 2� Fase - Teste para Verifica��o da Execu��o de Geradores e Funcionalidades
*		Nuno Reis (202000753)
*			Turma: 2�L_EI-SW-08 - sala F155 (14:30h - 16:30h)
*
********************************************/
/********************************************
*	Geradores
********************************************/
--Country
EXEC RH.country_insert 'Portugal', 'Europa';
EXEC RH.country_insert 'Portugal', 'Europa';--Repetido
EXEC RH.country_insert 'Espanha', 'Europa';
EXEC RH.country_update 2, 'Portugal', 'Europa';--Repetido
EXEC RH.country_update 3, 'Portugal', 'Europa';--N�o Existe
EXEC RH.country_update 2, 'Estados Unidos', 'America';
EXEC RH.country_delete 2;
EXEC RH.country_delete 3;--N�o Existe

--State Province
EXEC RH.stateProvince_insert 'Setubal', 'Se';
EXEC RH.stateProvince_insert 'Setubal', 'Se';--Repetido
EXEC RH.stateProvince_insert 'Washinton', 'Wa';
EXEC RH.stateProvince_update 3, 'Setubal', 'Se';--N�o Existe
EXEC RH.stateProvince_update 2, 'California', 'Ca';
EXEC RH.stateProvince_delete 2;
EXEC RH.stateProvince_delete 3;--N�o Existe

--City
EXEC RH.city_insert 'Palmela', 'Center', 19000;
EXEC RH.city_insert 'Palmela', 'Center', 19000;--Repetido
EXEC RH.city_insert 'San Diego', 'South', 1382000;
EXEC RH.city_update 3, 'Palmela', 'Center', 19000;--N�o Existe
EXEC RH.city_update 2, 'Oakland', 'East', 433823;
EXEC RH.city_delete 2;
EXEC RH.city_delete 3;--N�o Existe

--Category
EXEC RH.category_insert 'Padaria';
EXEC RH.category_insert 'Padaria';--Repetido
EXEC RH.category_insert 'Convinience';
EXEC RH.category_update 2, 'Padaria';--Repetido
EXEC RH.category_update 3, 'Padaria';--N�o Existe
EXEC RH.category_update 2, '24H';
EXEC RH.category_delete 2;
EXEC RH.category_delete 3;--N�o Existe

--Region Category
EXEC RH.country_insert 'Estados Unidos', 'America';
EXEC RH.stateProvince_insert 'Washinton', 'Wa';
EXEC RH.city_insert 'San Diego', 'South', 1382000;
EXEC RH.category_insert 'Convinience';

EXEC RH.regionCategory_insert 1, 1, 1, 1, 2222;
EXEC RH.regionCategory_insert 1, 1, 1, 1, 2222;--Repetido
EXEC RH.regionCategory_insert 2, 3, 3, 3, 2222;--Pais invalido
EXEC RH.regionCategory_insert 3, 2, 3, 3, 2222;--Estado invalido
EXEC RH.regionCategory_insert 3, 3, 2, 3, 2222;--Cidade invalida
EXEC RH.regionCategory_insert 3, 3, 3, 2, 2222;--Categoria invalida
EXEC RH.regionCategory_insert 3, 3, 3, 3, 2222;
EXEC RH.regionCategory_update 3, 1, 1, 1, 1, 2222;--N�o Existe
EXEC RH.regionCategory_update 2, 3, 3, 3, 3, 20938;
EXEC RH.regionCategory_delete 2;
EXEC RH.regionCategory_delete 3;--N�o Existe

--Buying Group
EXEC RH.buiyngGroup_insert 'IPS';
EXEC RH.buiyngGroup_insert 'IPS';--Repetido
EXEC RH.buiyngGroup_insert 'P';
EXEC RH.buiyngGroup_update 2, 'IPS';--Repetido
EXEC RH.buiyngGroup_update 3, 'IPS';--N�o Existe
EXEC RH.buiyngGroup_update 2, 'ISEL';
EXEC RH.buiyngGroup_delete 2;
EXEC RH.buiyngGroup_delete 3;--N�o Existe

--Sys User
EXEC RH.sysUser_insert 'IPS', 'ips@ips.com', 'Pass123';
EXEC RH.sysUser_insert 'IPS', 'ips@ips.com', 'Pass123';--Repetido
EXEC RH.sysUser_insert 'ISEL', 'isel@isel.com', 'Pass123';
EXEC RH.sysUser_update 3, 'IPS', 'ips@ips.com', 'Pass123';--N�o Existe
EXEC RH.sysUser_update 2, 'ISEL', 'isel123@isel.com', 'Pass123';
EXEC RH.sysUser_delete 2;
EXEC RH.sysUser_delete 3;--N�o Existe

--Customer
EXEC RH.sysUser_insert 'EST', 'est@ips.com', 'Pass123';

EXEC RH.customer_insert 1, 1, 1, 1, 'Ant�nio Jos�', 1;
EXEC RH.customer_insert 1, 1, 1, 1, 'Ant�nio Jos�', 1;--Repetido
EXEC RH.customer_insert 3, 1, 1, 1, 'Ant�nio Jos�', 0;
EXEC RH.customer_update 6, 1, 1, 1, 'Ant�nio Jos�';--N�o Existe - 2x
EXEC RH.customer_update 3, 1, 1, 1, 'Manuel Nunes';
EXEC RH.customer_delete 3;
EXEC RH.customer_delete 6;--N�o Existe

--Employee
EXEC RH.sysUser_insert 'Nuno Reis', 'nunoreis@ips.com', 'Pass123';
EXEC RH.sysUser_insert 'Jos� Gon�alves', 'josegoncalves@ips.com', 'Pass123';

EXEC RH.employee_insert 4, 'Nuno', 1;
EXEC RH.employee_insert 1, 'Nuno', 1;--Repetido
EXEC RH.employee_insert 1, 'Nuno', 0;--Customer
EXEC RH.employee_insert 5, 'Jos�', 0;
EXEC RH.employee_update 6, 'Jos�', 0;--N�o Existe
EXEC RH.employee_update 5, 'Jos�', 1;
EXEC RH.employee_delete 5;
EXEC RH.employee_delete 6;--N�o Existe

EXEC RH.customer_insert 4, 1, 1, 1, 'Ant�nio Jos�', 1;--Employee

--Token
EXEC RH.token_insert 4;
EXEC RH.token_insert 4;
EXEC RH.token_insert 5;
EXEC RH.token_insert 6;--N�o Existe
EXEC RH.token_update 2;
EXEC RH.token_update 10;--N�o Existe

--Tax Rate
EXEC Storage.taxRate_insert 23;
EXEC Storage.taxRate_insert 23;--Repetido
EXEC Storage.taxRate_insert 6;
EXEC Storage.taxRate_update 2, 23;--Repetido
EXEC Storage.taxRate_update 3, 23;--N�o Existe
EXEC Storage.taxRate_update 2, 11;
EXEC Storage.taxRate_delete 2;
EXEC Storage.taxRate_delete 3;--N�o Existe

--Product Type
EXEC Storage.productType_insert 'Seco';
EXEC Storage.productType_insert 'Seco';--Repetido
EXEC Storage.productType_insert 'Molhado';
EXEC Storage.productType_update 2, 'Seco';--Repetido
EXEC Storage.productType_update 3, 'Seco';--N�o Existe
EXEC Storage.productType_update 2, 'Congelado';
EXEC Storage.productType_delete 2;
EXEC Storage.productType_delete 3;--N�o Existe

--Package
EXEC Storage.package_insert 'Pacote';
EXEC Storage.package_insert 'Pacote';--Repetido
EXEC Storage.package_insert 'Saco';
EXEC Storage.package_update 2, 'Pacote';--Repetido
EXEC Storage.package_update 3, 'Pacote';--N�o Existe
EXEC Storage.package_update 2, 'Garafa';
EXEC Storage.package_delete 2;
EXEC Storage.package_delete 3;--N�o Existe

--Brand
EXEC Storage.brand_insert 'Nike';
EXEC Storage.brand_insert 'Nike';--Repetido
EXEC Storage.brand_insert 'Adidas';
EXEC Storage.brand_update 2, 'Nike';--Repetido
EXEC Storage.brand_update 3, 'Nike';--N�o Existe
EXEC Storage.brand_update 2, 'New Balance';
EXEC Storage.brand_delete 2;
EXEC Storage.brand_delete 3;--N�o Existe

--Product
EXEC Storage.product_insert 1, 1, 1, 1, 1, 'Ten�s AirForce', 'Preto', '46', 7, 12, 30, 'N/A', 18.00, 26.91, 0.400;
EXEC Storage.product_insert 1, 1, 1, 1, 1, 'Ten�s AirForce', 'Branco', '46', 7, 12, 30, 'N/A', 18.00, 26.91, 0.400;--Repetido
EXEC Storage.product_insert 1, 1, 1, 1, 1, 'Cal��es', 'Branco', 'L', 7, 12, 30, 'N/A', 18.00, 26.91, 0.400;
EXEC Storage.product_update 2, 1, 1, 1, 1, 1, 'Cal��es', 'Preto', 'L', 7, 12, 30, 'N/A', 18.00, 26.91, 0.400;
EXEC Storage.product_update 3, 1, 1, 1, 1, 1, 'Cal��es', 'Preto', 'L', 7, 12, 30, 'N/A', 18.00, 26.91, 0.400;--N�o Existe
EXEC Storage.product_delete 2;
EXEC Storage.product_delete 3;--N�o Existe

--Promotion
EXEC Storage.promotion_insert 'Nova Promo��o', '2042-08-25', '2032-08-25';--Datas Invalidas
EXEC Storage.promotion_insert 'Nova Promo��o', '2022-08-25', '2032-08-25';
EXEC Storage.promotion_insert 'Nova Promo��o', '2022-08-25', '2032-08-25';--Repetido
EXEC Storage.promotion_insert 'Promo��o', '2022-08-25', '2032-08-25';
EXEC Storage.promotion_update 2, 'No Promotion', '2022-08-25', '2032-03-25';
EXEC Storage.promotion_update 3, 'No Promotion', '2022-08-25', '2032-03-25';--N�o Existe
EXEC Storage.promotion_delete 2;
EXEC Storage.promotion_delete 3;--N�o Existe

--Product Promotion
EXEC Storage.product_insert 1, 1, 1, 1, 1, 'Cal��es', 'Branco', 'L', 7, 12, 30, 'N/A', 18.00, 26.91, 0.400;
EXEC Storage.promotion_insert 'Promo��o', '2022-08-25', '2032-08-25';

EXEC Storage.productPromotion_insert 1, 1;
EXEC Storage.productPromotion_insert 1, 1;--Repetido
EXEC Storage.productPromotion_insert 3, 1;
EXEC Storage.productPromotion_update 2, 1, 3;
EXEC Storage.productPromotion_update 3, 1, 3;--N�o Existe
EXEC Storage.productPromotion_delete 2;
EXEC Storage.productPromotion_delete 3;--N�o Existe

--Sale
EXEC Storage.productPromotion_insert 3, 3;
EXEC RH.employee_insert 5, 'Jos�', 0;
EXEC RH.customer_insert 3, 1, 1, 1, 'Ant�nio Jos�', 0;

EXEC Sales.sale_insert 1, 3, 4, 'Nova Venda';
EXEC Sales.sale_insert 1, 3, 4, 'Nova Venda';--Repetido
EXEC Sales.sale_insert 2, 3, 5, 'Nova Venda2';--Funcionario Invalido
EXEC Sales.sale_insert 2, 3, 4, 'Nova Venda2';
EXEC Sales.sale_update 2, 3, 4, 'Sale4';
EXEC Sales.sale_update 3, 3, 4, 'Sale4';--N�o Existe
EXEC Sales.sale_delete 2;
EXEC Sales.sale_delete 3;--N�o Existe

--Product-Promotion Sale
EXEC Sales.sale_insert 2, 3, 4, 'Nova Venda2';

EXEC Sales.productPromotionSale_insert 1, 1, 20;
EXEC Sales.productPromotionSale_insert 1, 1, 20;--Repetido
EXEC Sales.productPromotionSale_insert 3, 1, 50;--Quantidade Invalida
EXEC Sales.productPromotionSale_insert 3, 1, 5;
EXEC Sales.productPromotionSale_update 3, 1, 7;
EXEC Sales.productPromotionSale_update 3, 2, 7;--N�o Existe
EXEC Sales.productPromotionSale_delete 3, 1;
EXEC Sales.productPromotionSale_delete 3, 2;--N�o Existe

/********************************************
*	Funcionalidades
********************************************/
--Adicionar, Editar e Remover Utilizadores
EXEC RH.sysUser_insert 'Nuno Reis', 'nunoreis@ips.com', 'Pass123';
select * from RH.SysUser where SysUseName = 'Nuno Reis';
EXEC RH.sysUser_update 422, 'Nuno Reis', 'nunoreis123.com', 'Pass123';
select * from RH.SysUser where SysUseName = 'Nuno Reis';
EXEC RH.sysUser_delete 422;
select * from RH.SysUser where SysUseName = 'Nuno Reis';

--Recuperar Password
EXEC RH.sysUser_insert 'Nuno Reis', 'nunoreis@ips.com', 'Pass123';
EXEC RH.token_insert 423;
EXEC RH.sp_recuperarPassword 'nunoreis@ips.com', 989316, '123Pass';

--Alterar as datas de In�cio e Fim de uma promo��o
EXEC Storage.promotion_insert 'Nova Promo��o', '2022-08-25', '2032-08-25';
EXEC Storage.promotion_update 2, 'Nova Promo��o', '2012-08-25', '2022-03-25';

--Criar uma venda;
EXEC Sales.sale_insert 100000, 3, 403, 'Nova Venda';
select * from Sales.Sale where SalID = 100000;

--Adicionar um produto a uma venda;
EXEC Sales.productPromotionSale_insert 1, 100000, 10;
select * from Sales.ProductPromotion_Sale where ProdProm_SalSaleId = 100000;

--Alterar a quantidade de um produto numa venda;
EXEC Sales.productPromotionSale_update 1, 100000, 20;
select * from Sales.ProductPromotion_Sale where ProdProm_SalSaleId = 100000;

--Remover um produto de uma venda. Recebe um par�metro que indica se a venda � removida  no caso de n�o ter mais produtos associados;
EXEC Sales.productPromotionSale_delete 1, 100000;
select * from Sales.ProductPromotion_Sale where ProdProm_SalSaleId = 100000;
select * from Sales.Sale where SalID = 100000;

--Finalizar venda
Sales.sp_finishSale 100000;
select * from Sales.ProductPromotion_Sale where ProdProm_SalSaleId = 100000;
select * from Sales.Sale where SalID = 100000;