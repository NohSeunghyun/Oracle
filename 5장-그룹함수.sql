--5장--그룹함수 : 하나 이상의 행을 그룹으로 묶어 연산하여 총합, 평균 등 결과를 구함

--★count(*) 함수를 제외한 모든 그룹함수들은 null값을 무시.

--사원들의 급여 총액, 평균액, 최고액, 최저액 출력

select sum(salary)as "급여총액",
avg(salary),
max(salary),
min(salary)
from employee;

--최근에 입사한 사원과 가장 오래전에 입사한 사원의 입사일을 출력

select
max(hiredate) as "최근 사원",--별칭이 너무 길 경우 오류발생
min(hiredate) as "오래전 사원"
from employee;

--1-1. 그룹함수와 null값(145p참조)

--사원들의 커미션 총액 출력

select sum(commission) as "커미션 총액"
from employee;
--null값과 연산한 결과는 모두 null이 나오지만
--그룹함수 'count(*)'만 null포함.

--1-2. 행개수를 구하는 count함수
--count(*|distinct 컬럼명|(all) 컬럼명)*all생략가능. : 행 개수

--전체 사원수 구하기

select count(*) as "사원의수"
from employee;

--커미션을 받는 사원수

--방법1.

select count(commission) as "커미션을 받는 사원수"
from employee;--count(컬럼명):null제외

--방법2.

select count(*) as "커미션을 받는 사원수"
from employee
where commission is not null;

--직업(job)이 몇개 종류인가 구하기

select job
from employee;

--중복제외한 직업표시
select distinct job
from employee;

--직업의 개수 : distinct(중복 제외)

select count(distinct job) as "중복제외한 직업수"
from employee;

--직업의 개수 : all

select count(all job) as "all 한 직업수"--all생략가능
from employee;

--★★★1-3.그룹함수와 단순컬럼★★★매우중요★★★

select ename, max(salary)
from employee;
--오류. 이유는 그룹함수의 결과값은 1개, 그룹함수를 적용하지않은 컬럼은 결과가 여러개이기 때문에 매치가 안됨
--     ->max(salary)=가장큰월급 의 결과는 1개지만 ename은 여러결과가 나오기 때문

--2.데이터그룹 : GROUP BY-특정 컬럼을 기준으로 그룹별로 나눠야 할 경우
--★★주의 : group by절 뒤에 별칭을 사용하지 못함.반드시 컬럼명만 기술할 수 있다.

--소속 부서별로 평균 급여를 부서번호와 함께 출력

select dno, avg(salary)--결과4개,결과4개 매치됨.
from employee
group by dno
order by 1;--(=order by dno asc;--asc생략가능 desc생략불가


select avg(salary)--부서번호인 dno가 없으면 무엇을 의미하는지 모르기때문에 결과가 무의미함.
from employee
group by dno;

--group by 절에 명시하지 않은 컬럼을(여기서 ename을뜻함)select절에 사용하면 오류가 뜸. (출력개수가 달라서 매치가 불가능하기때문)
select dno, ename, avg(salary)
from employee
group by dno;--, ename;--★ename은 값(사람이름)이 전부 다르기때문에 그룹으로 묶을수없다.
--				->실행은 가능하나 dno별로 묶인것이 아니기때문에 무의미한결과가 나온다.
--				->각 개인의 월급과 부서번호가 나옴.

select dno, job, count(*), sum(salary), avg(salary)
from employee
group by dno, job
order by dno, job;--dno를 먼저 오름차순으로 정렬 후 job을 오름차순으로 정렬
/* 
 * ★★group by절 순서 매우 중요★★
 * 순서에 따라 결과값이 달라짐.
 * group by 절은 먼저 부서번호를 기준으로 그룹화한 다음
 * 해당 부서번호 그룹 내에서 직업을 기준으로 다시 그룹화
 */

--3.그룹 결과 제한 : having절(152p)
--그룹 함수의 결과 중 having절 다음에 지정한 조건을 넣어 그 값이 true인 그룹으로 결과 제한

--부서별 급여총액이 6000이상인 부서의 부서번호와 부서별 급여총액 구하기

select dno, sum(salary) as "급여 총액"
from employee
--where sum(salary)>=6000--조건=>오류발생. 그룹으로 묶어 결과를 그룹별로 나오게했기 때문에 그룹함수인 having절을 써야함
group by dno
having sum(salary)>=6000--+부서번호 기준으로 오름차순 정렬하기
order by 1;--화면에 출력되는 가로열 1번째가 dno이기때문에 dno순으로 생략된 asc(오름차순)정렬(desc:내림차순정렬)

--MANAGER를 제외하고 급여총액이 3000이상인 직급별 수와 급여 총액 구하기

--방법1.
select job, sum(salary)
from employee
where job != 'MANAGER'
group by job
having sum(salary)>=3000;
--정렬하라는 말이 없었으므로 정렬문구 생략

--방법2.
select job, sum(salary)
from employee
where job not like 'MANAGER'
group by job
having sum(salary)>=3000;

--오류발생.이유:그룹함수가 포함된 조건은 having절에서만 사용가능.
select job, sum(salary)
from employee
where job != 'MANAGER' and sum(salary)>=3000
group by job;
--having sum(salary)>=3000;

--★그룹함수는 "2번까지" 중첩해서 사용할 수 있다.

--직급별 급여평균의 최고값을 출력

--오류발생.이유:dno의 그룹별로 묶은값=3개 max(avg(salary))의 값=1개.매치 불가하므로 오류.
select dno, max(avg(salary))
from employee
group by dno;

--오류해결.
select max(avg(salary))
from employee
group by dno;--단,무엇을 기준으로 했는지가 나오지 않기때문에 무의미하다.


/*
 * 순서
 * select
 * from
 * where --조건
 * group by
 * having --그룹함수의 결과에 조건을 줌
 * order by --정렬
 */

/************************
 ***5장-그룹함수혼자해보기 ***
 ************************/

--1. 모든 사원의 급여 최고액, 최저액, 총액 및 평균 급여를 출력하시오.
--컬럼의 별칭은 결과 화면과 동일하게 지정하고 평균에 대해서는 정수로 반올림하시오.

select max(salary) as "급여 최고액", 
min(salary) as "급여 최저액", 
sum(salary) as "급여 총액", 
round(avg(salary)) as "평균 급여"
from employee;

--2.각 담당 업무 유형별로 급여 최고액, 최저액, 총액 및 평균급여를 출력하시오.
--컬럼의 별칭은 결과 화면과 동일하게 지정하고 평균에 대해서는 정수로 반올림하시오.

select job as "담당업무",
max(salary) as "급여 최고액", 
min(salary) as "급여 최저액", 
sum(salary) as "급여 총액", 
round(avg(salary)) as "평균 급여"
from employee
group by job;

--3. count(*)함수를 이용하여 담당업무가 동일한 사원 수를 출력하시오.

select job as "담당업무",
count(*) as "업무가 같은 사원수"
from employee
group by job;

--4.관리자 수를 나열하시오
--컬럼의 별칭은 화면과 동일하게 지정하시오.

--1)
select count(*) as "관리자의 수"
from employee
where job='MANAGER';

--2)
select job as "직급",
count(*) as "관리자의 수"
from employee
where job='MANAGER'
group by job;

--5.급여 최고액, 급여 최저액의 차액을 출력하시오.
--컬럼의 별칭은 화면과 동일하게 지정하시오.

select max(salary) as "급여 최고액",
min(salary) as "급여 최저액",
max(salary)-min(salary) as "차액"
from employee;

--6.직급별 사원의 최저 급여를 출력하시오.
--관리자를 알수 없는 사원 및 최저 급여가 1000미만인 그룹은 제외시키고
--결과를 급여에 대한 내림차순으로 정렬하여 출력하시오.

--1)
select job as "직급", 
min(salary) as "최저 급여"
from employee
where manager is not null
group by job
having min(salary)>=1000
order by 2 desc;

--2)
select job as "직급",
min(salary) as "최저 급여"
from employee
where manager is not null
group by job
having not min(salary)<1000
order by 2 desc;

--7.각 부서에 대해 부서번호, 사원수, 부서 내의 모든 사원의 평균 급여를 출력하시오.
--컬럼의 별칭은 결과 화면과 동일하게 지정하고 평균 급여는 소수점 둘째자리로 반올림하시오.
--(★단, 테이블을 조회하기 전에 salary의 null여부를 모른상태에서 조회한다면)=>NVL(salary,0)을 사용.
--★★하고난 후 든 생각 : 카운트함수와 라운드함수 사용법 더보기.

select dno as "부서번호", 
count(eno) as "사원수", 
round(avg(salary),2) as "평균 급여"
from employee
group by dno;

--8.각 부서에 대해 부서번호 이름, 지역명, 사원수, 부서내의 모든 사원의 평균 급여를 출력하시오.
--컬럼의 별칭은 결과 화면과 동일하게 지정하고 평균 급여는 정수로 반올림하시오.
--★★하고난 후 든 생각 : 하는법을 몰랐다.decode함수 사용법 더보기.

--방법1.decode함수 사용
select dno,
decode(dno,
10,'ACCOUNTING',
20,'RESEARCH',
30,'SALES',
40,'OPERATIONS') as "부서명",
decode(dno,
10,'NEW YORK',
20,'DALLAS',
30,'CHICAGO',
40,'BOSTON') as "지역명",
count(*) as "사원수",
round(avg(salary)) as "평균급여"
from employee
group by dno
order by 1;

--방법2.case end 사용
select dno,
case 
when dno=10 then 'ACCOUNTING'
when dno=20 then 'RESEARCH'
when dno=30 then 'SALES'
when dno=40 then 'OPERATIONS'
end as "부서명",
case 
when dno=10 then 'NEW YORK'
when dno=20 then 'DALLAS'
when dno=30 then 'CHICAGO'
when dno=40 then 'BOSTON'
end as "지역명",
count(ename) as "사원수",
round(avg(salary)) as "평균급여"
from employee
group by dno
order by 1;

--방법3.join 사용.아직안배움.
select dno, 
dname as "부서명",
loc as "지역명", 
count(eno) as "사원수", 
round (avg(salary)) as "평균급여"
from employee natural join DEPARTMENT
group by dno, dname, loc
order by 1;

/************************************************************************************************************************************/