--1. Show for each zoo the number of different species represented by its captive animals. 
SELECT ZooName, COUNT(DISTINCT S.SpeciesName) AS "# of Unique Species"
FROM Zoo Z INNER JOIN  Animal A 
ON Z.ZooName = A.[Zoo (FK)] INNER JOIN Species S ON
S.SpeciesName = A.[Species (FK)] GROUP BY ZooName;

--2. List the zoo name, employee name and salary of each employee that is a world’s best expert in a species. Sequence the output by employee name within zoo name.
SELECT Z.ZooName, E.EmpName, E.Salary FROM Zoo Z INNER JOIN Employee E ON
E.[Zoo (FK)] = Z.ZooName INNER JOIN Species S ON
E.EmpNo = S.[WorldBestExperEmpNo (FK)] WHERE E.EmpNo = S.[WorldBestExperEmpNo (FK)] 
ORDER BY Z.ZooName, E.EmpName;

--3. List the detail of animals that are in captivity in any zoo and whose mother is currently in the "Garden Zoo" in Boston.
SELECT * FROM Animal WHERE [MotherAnimalId (FK)] IN 
(SELECT AnimalId FROM Animal WHERE [Zoo (FK)] IN
(SELECT ZooName FROM Zoo WHERE ZooName = 'Garden Zoo' AND City = 'Boston'));

--4. Show for each zoo in Canada a count of captive animals.  Sequence the output by highest to lowest count.
SELECT Z.ZooName, COUNT(A.AnimalID) AS "# of Captive Animals in Canada"
FROM Zoo Z INNER JOIN Animal A ON A.[Zoo (FK)] = Z.ZooName 
WHERE Z.Country = 'Canada' 
GROUP BY Z.ZooName
ORDER BY COUNT(A.AnimalID) DESC;

--5. Show for each species a count of the experts that are employed by any zoos in the USA.
SELECT S.SpeciesName, COUNT(E.[SpeciesExpertise (FK)]) AS "Count of Experts in the USA"
FROM Employee E INNER JOIN Zoo Z ON Z.ZooName = E.[Zoo (FK)] INNER JOIN Species S
ON E.[SpeciesExpertise (FK)] = S.SpeciesName
WHERE Z.Country = 'USA'
GROUP BY S.SpeciesName;

--6. List the details for employees in any zoo in Canada that have either a salary of at least 75000 or are an expert in the Tiger species. Sequence the output by employee name.
SELECT * FROM Employee WHERE (Salary >= 75000 OR
[SpeciesExpertise (FK)] = 'Tiger') AND [Zoo (FK)] IN 
(SELECT ZooName FROM Zoo WHERE Country = 'Canada');

--7. List the details for all animals born in 2016 that belong to an endangered species (status = E). 
SELECT * FROM Animal WHERE YEAR(DateOfBirth) = 2016 AND [Species (FK)] IN
(SELECT SpeciesName FROM Species WHERE Status = 'E');

--8. List the details for the zoos in China that have more than 2 animals that belong to the Panda species.
SELECT * FROM Zoo WHERE Country = 'China' AND ZooName IN 
(SELECT [Zoo (FK)] FROM Animal WHERE [Species (FK)] = 'Panda' 
GROUP BY [Zoo (FK)] HAVING COUNT([Species (FK)]) > 2);

--9. List the names, gender and salaries of all male employees that are the world’s best expert for a threatened species (status = T).
SELECT EmpName, Gender, Salary FROM Employee 
WHERE Gender = 'M' AND EmpNo IN (SELECT [WorldBestExperEmpNo (FK)] FROM Species
WHERE Status = 'T');

--10. List the details of the zoo that has the employee with the highest salary in any zoo.
SELECT Z.* FROM Zoo Z INNER JOIN Employee E
ON Z.ZooName = E.[Zoo (FK)]
WHERE E.Salary = (SELECT MAX(Salary) FROM Employee);

--11. List the details for any species for which there animals held in any zoo in China.
SELECT DISTINCT S.* FROM Species S INNER JOIN Animal A
ON S.SpeciesName = A.[Species (FK)] INNER JOIN Zoo Z
ON A.[Zoo (FK)] = Z.ZooName
WHERE Z.Country = 'China';

--12. List the details for the zoos that have animals belonging to more than 3 different species. Sequence the output alphabetically by zoo within city.
SELECT Z.* FROM Zoo Z INNER JOIN Animal A
ON Z.ZooName = A.[Zoo (FK)] INNER JOIN Species S
ON A.[Species (FK)] = S.SpeciesName
GROUP BY Z.ZooName, Z.City, Z.AnnualNoVisiter, Z.Country
HAVING COUNT(DISTINCT S.SpeciesName) > 3
ORDER BY Z.City, Z.ZooName;

--13. List details for the animals that have a mother that is in a zoo that is different from their child's current zoo.
SELECT A.* FROM Animal A INNER JOIN Animal M
ON A.[MotherAnimalId (FK)] = M.AnimalId
WHERE M.[Zoo (FK)] != A.[Zoo (FK)];

--14. Show the name of any country that has the more than 2 zoos.
SELECT Country FROM Zoo
GROUP BY Country
HAVING COUNT(Country) > 2;

--15. List the species details for the species that have a world’s best expert working in a zoo that also has animals of that same species. Show each species only once.
SELECT DISTINCT S.* FROM Species S INNER JOIN Animal A
ON S.SpeciesName = A.[Species (FK)] INNER JOIN Zoo Z
ON A.[Zoo (FK)] = Z.ZooName INNER JOIN Employee E
ON Z.ZooName = E.[Zoo (FK)]
WHERE E.EmpNo = S.[WorldBestExperEmpNo (FK)] AND
E.[Zoo (FK)] = A.[Zoo (FK)];

--16. List the details for the employee that has the lowest salary for an expert in the Tiger species.
SELECT * FROM Employee
WHERE [SpeciesExpertise (FK)] = 'Tiger' AND
Salary = (SELECT MIN(Salary) FROM Employee WHERE [SpeciesExpertise (FK)] = 'Tiger');

--17. List the details for any endangered species for which there are more than 2 individual animals in total in Canadian zoos.
SELECT * FROM Species WHERE Status = 'E' AND SpeciesName IN
(SELECT [Species (FK)] FROM Animal A INNER JOIN ZOO Z ON
A.[Zoo (FK)] = Z.ZooName WHERE Z.Country = 'Canada' 
GROUP BY [Species (FK)] HAVING COUNT([Species (FK)]) > 2);

--18. List the details of any zoo that has more than 2 Lions born in 2016.
SELECT Z.* FROM Zoo Z INNER JOIN Animal A
ON Z.Zooname = A.[Zoo (FK)]
WHERE YEAR(A.DateOfBirth) = 2016 AND A.[Species (FK)] = 'Lion'
GROUP BY Z.ZooName, Z.City, Z.AnnualNoVisiter, Z.Country
HAVING COUNT(*) > 2;

--19. Show the count of how many species experts are employed at the "Metro Zoo" in Toronto.
SELECT COUNT(E.[SpeciesExpertise (FK)]) AS "Species Experts at Metro Zoo"
FROM Employee E INNER JOIN Zoo Z
ON E.[Zoo (FK)] = Z.ZooName
WHERE E.[Zoo (FK)] = 'Metro Zoo' AND Z.city = 'Toronto';

 --20 List the details of mothers that have more than 2 offspring in total in all Canadian zoos.
SELECT * FROM Animal WHERE AnimalId IN
(SELECT A.[MotherAnimalId (FK)] FROM Animal A INNER JOIN Zoo Z ON
A.[Zoo (FK)] = Z.ZooName WHERE Z.Country = 'Canada'
GROUP BY A.[MotherAnimalId (FK)] HAVING COUNT(A.AnimalId) > 2);
