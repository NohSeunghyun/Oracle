--<북스-11장. 뷰>
--1. 뷰(view)? 하나 이상의 테이블이나 다른 뷰를 이용하여 생성되는 '가상 테이블'
--즉, 실질적으로 데이터를 저장하지 않고 데이터사전에 뷰를 정의할 때 기술한 '쿼리문만 저장'

--기본 테이블 : 뷰를 정의하기 위해 사용된 테이블
--뷰는 별도의 기억공간이 존재하지 않기 때문에 뷰에대한 수정결과는 뷰를 정의한 기본테이블에 적용됨
--반대로 기본테이블의 데이터가 변경되면 뷰에 변경된 데이터 반영됨
--뷰를 정의한 기본테이블의 무결성 제약조건 역시 상속
--뷰의 정의 조회하려면 : user_viewS 데이터사전 이용

--<실습 위해 새로운 테이블 2개 생성>
create table emp11
as
select *
from employee;

create table dept11
as
select *
from department;
--테이블 구조와 데이터 복사(★★단, 제약조건은 복사안됨)

--[1] 단순 뷰(예)
create view v_emp_job
as
select eno, ename, dno, job
from emp11
where job like 'SALESMAN';

--생성확인
select * from v_emp_job;


create view v_emp_job2
as
select eno, ename, dno, job
from emp11
where job like 'SALESMAN';

--생성확인
select * fom v_emp_job2;

--생성한 v_emp_job2의 job을 SALESMAN->MANAGER로 변경
create view v_emp_job2
as
select eno, ename, dno, job
from emp11
where job like 'MANAGER'; --오류 같은이름의 뷰가 존재하므로

--위 오류 해결법
--or replace : 이미 존재하는 뷰는 내용을 새롭게 변경하여 재생성
--				존재하지 않는 뷰는 뷰를 새롭게 생성
--따라서 create or raplace view 를 사용하여 융통성있게 뷰 생성하는것을 권장
create or replace view v_emp_job2
as
select eno, ename, dno, job
from emp11
where job like 'MANAGER';

--덮어씌운것 확인
select * from v_emp_job2;

--[2] 복합 뷰(예)
create view v_emp_complex
as
select *
from emp11 natural join dept11;

--생성확인
select *
from v_emp_complex;

--[3] 뷰의 필요성
--1) 보안 : 중요한 데이터가 외부에 공개되는 것을 막을 수 있다.예)급여, 커미션

--2) 사용의 편의성 : 뷰는 복잡한 쿼리를 단순화시킬 수 있다.
--예)
create view v_emp_complex2
as
select dno, dname, loc, eno, ename --보안을위해 급여,커미션 제외
from emp11 natural join dept11;

select * from v_emp_complex2;

--코딩실수(보여줄 컬럼을 잘못적거나 함수 수정,컬럼 수정)로 인한 뷰 수정하는법
--방법1) 잘못만든 뷰 제거 후 코드 수정후 재생성
drop view v_emp_complex2;
--방법2) or replace 사용
create or replace view v_emp_complex2
as
select dno, dname, loc, eno, ename, salary
from emp11 natural join dept11;

--[4] 뷰의 처리 과정
select view_name, text
from user_viewS;

--user_viewS 데이터사전에 사용자가 생성한 '모든 뷰에 대한 정의'를 저장
--뷰는 select문에 이름을 붙인 것
--1) 뷰에 질의를 하면 오라클 서버는 user_viewS에서 뷰를 찾아 서브쿼리문을 실행
--2) 서브쿼리문은 기본테이블을 통해 실행됨

--뷰 테이블(v_emp_job)에 데이터 추가
insert into v_emp_job values (8000, '홍길동', 30, 'SALESMAN');--기본테이블 emp11(employee로 부터 복사 ★제약조건은 복사 안되있음)
--뷰 정의에 포함되지 않은 컬럼 중에 기본테이블의 컬럼이 not null 제약조건이 지정되어 있는 경우 insert문 사용 불가능

insert into v_emp_job values (9000, '이길동', 30, 'MANAGER');--기본테이블 emp11에는 추가 되었으나
--view테이블에는 추가가 안됨 이유? view테이블(v_emp_job)은 기본테이블(emp11)에서 job이 'SALESMAN'인것만 보여주기때문에 

--추가 확인
select  * from v_emp_job;--뷰 테이블에 추가확인
select  * from emp11;--기본 테이블에 추가확인
select  * from employee;--원본 테이블 추가확인
--1. 당연히 뷰 테이블에는 데이터가 추가가 되고 뷰를 생성하기위해 필요한 기본테이블에도 연쇄적으로 추가된것이 확인된다.
--2-1. 하지만 뷰를 생성하기위한 기본테이블은 원본테이블의 복사본. 즉, 원본테이블에는 추가되지 않은것이 확인된다.
--2-2. 그리고 기본테이블은 복사본이기때문에 제약조건이 복사되어있지 않기때문에 insert가능.

--뷰 테이블 데이터 삭제
delete v_emp_job
where eno=8000;--데이터 추가와 마찬가지로 삭제 또한 뷰테이블과 기본테이블 둘다 데이터가 삭제됨

--삭제확인
select * from v_emp_job;
select * from emp11;

--만약 뷰테이블에는 추가안되고 기본테이블에만 추가된경우 예)뷰테이블은 SALESMAN인데 MANAGER를 잘못 추가했을때
delete v_emp_job
where eno=9000;

--삭제확인
select * from emp11;--기본테이블에 삭제안됨
--삭제는 뷰테이블에서 하면 실행은되나 뷰테이블 자체에 해당하는 데이터가 없기 때문에 기본테이블에 삭제가 안되있다. 그래서 삭제하려면 기본테이블에서 삭제해야함.
-- ↓ 기본테이블에서 삭제해야함
delete emp11
where eno=9000;

--삭제확인
select * from emp11;

--뷰테이블(v_emp_job),기본테이블(emp11), 원본테이블(employee) 제약조건확인 -> 기본테이블에 제약조건없는것 확인 = 자동으로 뷰에도 제약조건없음
select *
from user_constraintS
where table_name in('EMPLOYEE', 'EMP11', 'V_EMP_JOB');-- in 사용할경우 대문자로 해야함
--where lower(table_name) in ('employee', 'emp11', 'v_emp_job');으로 사용가능
--★lower(컬럼명)을 쓸 경우 무조건 소문자로 사용해야됨.

--뷰 생성
create view v_emp_salary
as
select dno, sum(salary) as "급여 합계", avg(salary)as "급여 평균"
from emp11
group by dno;-- 함수 옆에 별칭 없을시 must name this expression with a column alias 오류발생 이유? 함수에 별칭이 있어야한다

--코딩실수(보여줄 컬럼을 잘못적거나 함수 수정,컬럼 수정)로 인한 뷰 수정하는법
--방법1) 잘못만든 뷰 제거 후 코드 수정후 재생성
drop view v_emp_salary;
--방법2) or replace 사용
create or replace view v_emp_salary
as
select dno, sum(salary) as "급여 합계", round(avg(salary),2) as "급여 평균"
from emp11
group by dno;

--생성확인
select * from v_emp_salary;

--예) 그룹함수를 가상컬럼으로 갖는 뷰는 DML(데이터 조작어 :insert, update, delete)사용 못함
insert into v_emp_salary values (50, 2000, 2000);--오류

---------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
--★교재 없는 내용
--<단순 뷰에서 DML명령어 사용이 불가능한 경우>
--1) 뷰 정의에 포함되지않은 컬럼중에 기본 테이블의 컬럼이 not null제약조건이 지정 되어있는 경우
--insert문 사용불가능
--왜냐면 뷰에대한 insert문은 기본테이블의 null값을 입력하는 형태가 되기 때문이다

--2) salary*12와 같이 산술표현식으로 정의된 가상컬럼이 뷰에적용되면 insert나 update가 불가능

--3) distinct를 포함한 경우에도 DML명령 사용이 불가능

--4) 그룹함수나 group by 절을 포함한 경우에도 DML명령 사용이 불가능
---------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
--[5] 뷰 제거 : 뷰를 제거한다는 것은 user_viewS 데이터사전에 뷰의 정의를 제거
--drop view 뷰이름;

---------------------------------------------------------------------------------------------------------------------------------------
--2. 다양한 뷰 옵션
--2-1. or replace

--2-2. force
--기본테이블이 없는 가상 뷰 테이블을 생성
create or replace view v_emp_notable--or replace를 자주 사용하여 손에 익히고자 사용한것임 or replace는 기존것을 덮어씌우는 개념
as
select eno, ename, dno, job
from emp_notable --존재하지않는 기본테이블
where job like 'MANAGER';--이 상태로 실행하면 오류발생. 해결하려면 force추가

--위 오류 해결
create or replace force view v_emp_notable
as
select eno, ename, dno, job
from emp_notable --존재하지않는 기본테이블
where job like 'MANAGER';

--생성확인
select * from v_emp_notable; --기본테이블이 없는 가상 뷰테이블 생성조회가안됨

--데이터사전에서 확인
select view_name
from user_viewS;--생성되어있다.
--v_emp_notable만 모든 것 조회
select *
from user_viewS
where lower(view_name) = 'v_emp_notable'; --in을 사용할 경우 ('대문자') =을 사용할경우 '대,소문자' . in은 여러개 가능 =은 하나만 가능
--하지만 lower(컬럼명)을 안쓸 경우 =을 쓰더라도 무조건 대문자여야함.

--2-3. with check option
--뷰 테이블(v_emp_job)에 데이터 추가
insert into v_emp_job values (9001, '이순신', 40, 'MANAGER');

--추가확인
select * from v_emp_job; 
select * from emp11;--당연히 v_emp_job은 job이 SALESMAN인것만 보여주기 때문에 위 쿼리 실행된것은 안나온다.하지만 기본테이블에는 들어와있다.=>혼돈 발생

--혼돈 발생을 막기 위해(미연에 방지하기 위해) with check option 사용하여 기본테이블에도 추가될수 없도록 방지
--즉, with check option으로 뷰를 생성할때 조건 제시에 사용된 컬럼값을 변경하지 못하도록함
create or replace view v_emp_chk
as
select eno, ename, dno, job
from emp11
where job like 'SALESMAN' with check option;

insert into v_emp_chk values (9003, '김유신', 40, 'MANAGER');--오류 : 추가안됨
--with check option : 조건제시를 위해 사용한 컬럼값이 아닌값에 대해서는 뷰를 통해서 추가/변경하지 못함

insert into v_emp_chk values (9003, '김유신', 40, 'SALESMAN');--추가됨

--2-4. with read only
--select문만 가능(조회만 가능), DML 사용못함
create or replace view v_emp_readonly
as
select eno, ename, dno, job
from emp11
where job like 'SALESMAN' with read only;

select * from v_emp_readonly;
insert into v_emp_readonly values (9004, '강감찬', 30, 'SALESMAN');--실패. 조회만 가능하게 만들어놨기 때문에

/************************
 ******11장-혼자해보기******
 ************************/
--문제1.20번 부서에 소속된 사원의 사원번호와 이름과 부서번호를 출력하는 select문을 하나의 뷰(v_em_dno)로 정의하시오
create view v_em_dno --생성할 때도 or replace사용가능 손에 익히기위해 or replace를 자주 사용하자
as
select eno, ename, dno
from employee
where dno = 20;

--생성확인
select * from v_em_dno;

--문제2.이미 생성된 뷰(v_em_dno)에 대해서 급여 역시 출력할수 있도록 수정하시오
create or replace view v_em_dno
as
select eno, ename, dno, salary
from employee
where dno = 20;

--수정확인
select * from v_em_dno;

--문제3.생성된 뷰(v_em_dno)를 제거하시오
drop view v_em_dno;

--제거확인
select *
from user_viewS;

--더 정확히 제거확인
select *
from user_viewS
where view_name = 'V_EM_DNO';--이렇게 쓸 경우 =을 사용하더라도 무조건 대문자로해야함
--위와 다르게
select *
from user_viewS
where lower(view_name) = 'v_em_dno';--이렇게 쓸 경우 대,소문자로 사용해도됨

/**************************************************************************************************************************************/