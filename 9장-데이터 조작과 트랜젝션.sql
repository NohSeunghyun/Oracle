--<북스-9장. 데이터 조작과 트랜젝션>
--데이터 조작어(DML : Data Manipulation Language) ★외부평가에 가끔 나옴
--1. INSERT : 데이터 입력
--2. UPDATE : 데이터 수정
--3. DELETE : 데이터 삭제
--모든 조작 행위들을 데이터 갱신했다고 표현
--위 작업 후 RUNSQL~에서는 commit을 사용하여 저장해주어야함.

/*
 * ★★ DELETE(DML:데이터조작어), TURNCATE, DROP(DDL:데이터정의어) 명령어의 차이점
 *    (DELETE, TURNCATE, DROP 명령어는 모두 삭제하는 명령어지만 중요한 차이점이 있다.)
 * 1.DELETE명령어 : 데이터는 지워지지만 테이블의 용량은 줄어들지 않는다.
 * 				    원하는 데이터만 지울 수 있다.
 * 				    삭제 후 잘못 삭제한 것을 되돌릴 수 있다.(rollback)
 * 
 * 2.TRUNCATE명령어 : 용량이 줄어들고, 인덱스 등도 모두 삭제된다.
 * 					테이블은 삭제하지는 않고, 데이터만 삭제한다.
 * 					한꺼번에 다 지워야한다.
 * 					삭제 후 절대 되돌릴 수 없다.
 * 
 * 3.DROP명령어 : 테이블 전체를 삭제, 공간, 객체를 삭제한다.
 * 				  삭제 후 절대 되돌릴 수 없다.
 */

--commit, rollback : DML(데이터조작어)

---------------------------------------------------------------------------------------------------------------------------------------
--1.INSERT문 : 테이블에 내용 추가
--문자 (char, varchar2)와 날씨(date)는 ''를 사용

--실습을 위해 기존의 부서테이블의 구조만 복사
create table dept_copy
as
select *
from department
where 0=1;--조건이 무조건 거짓

--구조 복사 확인
--일반적 방법
select * from dept_copy;
--RUN SQL~에서 확인
desc dept_copy;

--방법1.                      저장된 컬럼의 순서에 맞게 값 입력
insert into dept_copy values (10, 'accounting', '뉴욕');
--방법2.               저장된 컬럼을 임의의 순서로 지정, 그 순서에 맞게 값 입력
insert into dept_copy(dno, loc, dname) values (20, '달라스', 'research');--copy()안에 컬럼명을 적을 때 해당 컬럼에 맞게 values()괄호안에 순서대로 넣어야함.

--이클립스는 auto commit을 사용하여 자동으로 저장시켜주나, RUN SQL~에서 작업할 시 위 작업 후 commit을 시켜줘야한다.
--commit : 영구적으로 데이터 저장
--runsql 예) insert into dept_copy values (10, 'accounting', '뉴욕');->commit;

commit;--이클립스에서는 자동commit되어  명령어가 실행안됨(RUN SQL~에서 실행 또는 SQL developer에서 실행)

--입력 확인
--일반적 방법
select * from dept_copy;
--RUN SQL~에서 확인
select * from dept_copy;

--1-1.NULL값을 갖는 ROW 삽입
--문자나 날짜 타입은 null 대신 ''사용가능
--예)
--방법1.
insert into dept_copy(dno, dname) values (30, 'sales');--null값을 허용했을 때만 null이 저장됨.
--null값 생략 : default '대구'(이 컬럼값은 loc이기때문에 대구)로 지정되어 있다면 값을 생략했을때 '대구'로 자동입력됨
--입력 확인
--일반적 방법
select * from dept_copy;
--RUN SQL~에서 확인
select * from dept_copy;

--방법2.
insert into dept_copy values (40, 'operations', 'null');

--입력 확인
--일반적 방법
select * from dept_copy;
--RUN SQL~에서 확인
select * from dept_copy;

--방법3.
insert into dept_copy values (50, 'compution', '');

--입력 확인
--일반적 방법
select * from dept_copy;
--RUN SQL~에서 확인
select * from dept_copy;

--실습을 위해 기본 사원테이블 구조만 복사

create table emp_copy
as
select eno, ename, job, hiredate, dno
from employee
where 0=1;

--구조 복사 확인
--일반적 방법
select * from emp_copy;
--RUN SQL~에서 확인
desc emp_copy;

insert into emp_copy values(7000, '캔디', 'manager', '2021/07/01', 10);
--commit;

--날짜 기본 형식 : 'yy/mm/dd'

insert into emp_copy values(7010, '톰', 'manager', to_date('2021,06,01','yyyy,mm,dd'), 10);--to_date : 지정한 수를 지정한 형식으로 저장
insert into emp_copy values(7020, '제리', 'manager', sysdate, 10);--sysdate : 시스템으로부터 현재 날짜 데이터 반환하는 함수

--입력 확인
--일반적 방법
select * from emp_copy;
--RUN SQL~에서 확인
select * from emp_copy;

--1-2.다른 테이블에서 데이터 복사하기
--insert into + 다른테이블의 서브쿼리 결과 데이터 복사
--단, 컬럼수 = 서브쿼리 컬럼수 일치해야함

drop table dept_copy;--위에 만들어서 데이터를 넣어놨기 때문에 삭제.

create table dept_copy
as
select * from department
where 0=1;--구조만 복사

--예)서브쿼리로 다중 행 입력
insert into dept_copy
select * from department;

--데이터 복사된것 확인
select * from dept_copy;

---------------------------------------------------------------------------------------------------------------------------------------
--2.UPDATE문 : 테이블의 내용 수정
--where 절 생략 : 테이블의 모든 행 수정됨
--예)
--where절 생략안함
update dept_copy
set dname='programming'
where dno=10;

--수정 확인 : where절 생략되있지 않기때문에 dno가10인것의 dname이 programming으로 바뀜
select * from dept_copy;

--where절 생략함
update dept_copy set dname='JAVA';--수업 진행을 위해 실행은 안함.

--수정 확인 : where절 생략되었기 때문에 모든 dname이 JAVA로 바뀜.
select * from dept_copy;

--컬럼값 여러개 한번에 수정하기
update dept_copy
set dname='accounting', loc='서울'
where dno=10;

--수정확인
select * from dept_copy;

--update문의 set절에서 서브쿼리를 기술하면 서브쿼리를 수행한 결과로 내용이 변경됨
--즉, 다른 테이블의 저장된 데이터로 해당 컬럼의 값으로 변경가능
--예) 10번부서의 지역명을 20번부서의 지역명으로 변경
--[1]20번부서의 지역명 구하기
select loc
from dept_copy
where dno=20;

--[2]
update dept_copy
set loc=(select loc from dept_copy where dno=20)
where dno=10;

--수정확인
select * from dept_copy;

--예) 10번부서의 부서명과 지역명을 30번부서의 부서명과 지역명으로 변경
--방법1. 더욱 간결함
--[1]30번부서의 부서명과 지역명 구하기
select dname, loc
from dept_copy
where dno=30;

--[2]
update dept_copy
set (dname, loc)=(select dname, loc from dept_copy where dno=30)
where dno=10;

--방법2.
--[1]30번부서의 부서명과 지역명 구하기
select dname from dept_copy where dno=30;
select loc from dept_copy where dno=30;

--[2]
update dept_copy
set dname=(select dname from dept_copy where dno=30),--서브쿼리의 결과는 단 1개만
	loc=(select loc from dept_copy where dno=30)
where dno=10;

--수정확인
select * from dept_copy;

---------------------------------------------------------------------------------------------------------------------------------------
--3.DELETE문 : 테이블의 내용 삭제
--where절 생략 : 모든 행 삭제
--where절 생략안함
delete dept_copy where dno=10; -- delete from dept_copy : from 생략가능

--삭제확인
select * from dept_copy;

--where절 생략
delete dept_copy;--안의 데이터가 전부 삭제됨. 구조만 남음

--삭제확인
select * from dept_copy;

--실습을 위해 사원테이블의 구조와 데이터 복사->새 테이블 생성
drop table emp_copy;--위에 만들어서 데이터를 넣어놨기 때문에 삭제

create table emp_copy
as
select * from employee;

--예) emp_copy테이블에서 영업부 sales에 근무하는 사원 모두 삭제
--삭제하기전 SALES 근무자 수 확인 (삭제 후 그만큼 삭제됐는지 확인하기위해)
select dno from department where dname='SALES';
select ename from emp_copy where dno=30;

delete emp_copy
where dno=(select dno from department where dname='SALES');

--삭제확인
select * from emp_copy;
--더 정확히 확인
select ename, dname
from emp_copy natural join department;

---------------------------------------------------------------------------------------------------------------------------------------
--4.트랜젝션 관리
--오라클은 트랜젝션 기반으로 데이터의 일관성을 보장함
--예 : 두 계좌
--'출금계좌의 출금금액'과'입금계좌의 입금금액'이 동일해야 함
-- update            insert
--반드시 두 작업은 함께 처리되거나 함께 취소
--출금 처리는 되었는데 입금 처리가 되지 않았다면 데이터의 일관성을 유지못함
--트랜젝션 처리조건 : ALL-or-Nothing 반드시 처리되던가 안되던가
--               데이터의 일관성을 유지, 안정적으로 데이터 복구

--commit   : 데이터를 추가, 수정, 삭제 등 실행됨과 동시에 트랜젝션이 진행됨
--		          성공적으로 변경된 내용을 영구적으로 저장하기 위해 commit을 사용해야함

--rollback : 작업을 취소
--			  트랜젝션으로 인한 하나의 묶음 처리가 시작되기 이전 상태로 되돌림

--실습을 위해 기존 부서테이블의 구조와 데이터 복사->새 테이블
drop table dept_copy;--기존 테이블 삭제

create table dept_copy
as
select *
from department;

--복사확인
select * from dept_copy;

--rollback사용

--방법1.RUN SQL~에서

savepoint a;

delete dept_copy;
where dno=10;
savepoint d10;

delete dept_copy;
where dno=20;
savepoint d20;

delete dept_copy;
where dno=30;
savepoint d30;

--삭제확인
select * from dept_copy;

rollback to d30;--30번부서 삭제한 상황으로 돌아감.

rollback to d20;--20번부서 삭제한 상황으로 돌아감.

rollback to d10;--10번부서 삭제한 상황으로 돌아감.

rollback to a;--모두 삭제전인 a포인트로 돌아감

commit;

--복구확인
select * from dept_copy;

--방법2.RUN SQL~에서 

delete dept_copy;

--commit을쓰면 영구저장되기때문에 사용x

select * from dept_copy;--를 쓰면 삭제된것 확인.

rollback;

commit;

select * from dept_copy;--로 확인하면 다시살아남.

/************************
 ******9장-혼자해보기*******
 ************************/

--문제1.employee테이블의 구조만 복사하여 emp_insert란 이름의 빈 테이블을 만드시오.
drop table emp_insert;--원상복구

create table emp_insert
as
select *
from employee
where 0=1;

--생성확인
select * from emp_insert;

--문제2.본인을 emp_insert 테이블에 추가하되 sysdate를 이용해서 입사일을 오늘로 입력하시오.
insert into emp_insert values(2 ,'노승현' ,'manager' ,1 ,sysdate ,1000 ,null ,10);

--입력확인
select * from emp_insert;

--문제3.emp_insert 테이블에 옆사람을 추가하되 to_date함수를 이용해서 입사일을 어제로 입력하시오.
insert into emp_insert values(3 ,'김경탄' ,'manager' ,1 ,to_date('20210630', 'yyyymmdd') ,2000 ,null ,20);

--입력확인
select * from emp_insert;

--문제4.employee테이블의 구조와 내용을 복사하여 emp_copy란 이름의 테이블을 만드시오.
drop table emp_copy;--원상복구

create table emp_copy
as
select *
from employee;

--생성확인
select * from emp_copy;

--문제5.사원번호가 7788인 사원의 부서번호를 10번으로 수정하시오.
update emp_copy
set dno=10
where eno=7788;

--변경확인
select * from emp_copy;

--문제6.사원번호 7788의 담당 업무 및 급여를 사원번호 7499의 담당 업무 및 급여와 일치하도록 갱신하시오.
--[1] 7499의 업무 및 급여확인
select job, salary
from emp_copy
where eno=7499;

--[2]
update emp_copy
set (job, salary)=(select job, salary
				   from emp_copy
				   where eno=7499)
where eno=7788;

--변경확인
select * from emp_copy;

--문제7.사원번호가 7369와 업무가 동일한 모든 사원의 부서번호를 사원 7369의 현재 부서번호로 갱신하시오.
--[1] 7369의 업무
select job
from emp_copy
where eno=7369;

--[2] 7369의 부서번호
select dno
from emp_copy
where eno=7369;

--[3]
update emp_copy
set dno=(select dno
		 from emp_copy
		 where eno=7369)
where job=(select job
		   from emp_copy
		   where eno=7369);

--변경확인
select * from emp_copy;

--문제8.department테이블의 구조와 내용을 복사하여 dept_copy란 이름의 테이블을 만드시오.
drop table dept_copy;--원상복구

create table dept_copy
as
select *
from department;

--생성확인
select * from dept_copy;

--문제9.dept_copy테이블에서 부서명이 RESEARCH인 부서를 제거하시오.
delete dept_copy
where dname='RESEARCH';

--삭제확인
select * from dept_copy;

--문제10.dept_copy테이블에서 부서번호가 10이거나 40인 부서를 제거하시오.
--방법1.
delete dept_copy
where dno=10 or dno=40;

--방법2.
delete dept_copy
where dno in (10, 40);

--삭제확인
select * from dept_copy;

--☆ a (in or any) b = a (이거나, 또는) b 이다(=교집합)
--☆ a all b = a 이고 b 이다(=합집합)

/**************************************************************************************************************************************/