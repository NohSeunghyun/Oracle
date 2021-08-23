--SQL 활용 정리

--1.DDL:데이터정의어
-- 테이블생성 : create
-- 컬럼명변경 : rename
-- 컬럼추가 : add
-- 테이블(컬럼) 삭제 : drop table(+column)
-- 컬럼타입,크기변경 : modify

drop table test;

--1).테이블 생성
테이블명 - test
컬럼 - 필드           타입              null         key        default 
      id        varchar2(20)          no                      null 
   password     varchar2(30)          no                      null
     name       varchar2(25)          no                      null
     성별           char(2)            yes                     null
    birth          date               yes                     null
     age          number(4)           yes                     null
     
create table test(
id varchar2(20) not null,
password varchar2(30) not null,
name varchar2(25) not null,
성별 char(2),
birth date,
age number(4)
);

--생성확인(구조만 확인하기 위해선 RUN SQL~에서 desc test;사용)
select *
from test;

--2).컬럼명 변경 - 성별->gender
alter table test
rename column 성별 to gender;

--변경확인
select *
from test;

--3).컬럼 추가 - address varchar2(60)
alter table test
add address varchar2(60);

--추가확인
select *
from test;

--4).컬럼 삭제 - 생년월일(=birth) 
alter table test
drop column birth;

--삭제확인
select *
from test;

--5).컬럼 타입 수정 - age number(4) -> age number(3) null:no default:0 으로 수정

/*
 * 컬럼의 길이를 줄일 때 주의사항
 * 컬럼의 길이를 줄일경우 해당 컬럼의 값중 변경할 길이보다 큰값이 있으면 오류발생
 * 이럴때 해당컬럼의 길이를 조회하여 변경할 길이보다 큰값이 있는지 확인하고 값변경해야함
 */

select *
from test
where length(age) > 3;--결과가 존재하면 크기를 3으로 줄일 수 없다.

alter table test
--modify age number(3) not null default 0;--★주의:not null + default 한번에 쓸 시 default를 앞에 notnull을 뒤에 써야 오류발생안함.
modify age number(3) default 0 not null;--★age컬럼안에 데이터가 없기 때문에 타입크기를 더 작게 수정가능.(=입력한 row가 없으므로 컬럼크기를 줄일수있다)

--수정확인(타입,크기는 runSQL~에서 desc test로 확인)
desc test

--6).컬럼 타입 수정 - gender char(2) -> gender char(1) default:'M'
alter table test
modify gender char(1) default 'M';

--수정확인(타입,크기는 runSQL~에서 desc test로 확인)
desc test;

--7).제약조건 추가 - id를 기본키로 - 알아보기 쉽게 제약조건 이름을 지정해줌.(test_id_pk로)
alter table test
add constraint test_id_pk primary key(id);

--제약조건 추가 확인
select *
from user_constraintS
where table_name in ('TEST');--in대신 부등호 '='도 사용가능.단, 조회하고자하는 것이 하나일경우에만 두개 이상일경우 in을 사용해야함

--8).제약조건 제거
alter table test
drop constraint TEST_ID_PK;

--제약조건 제거 확인
select *
from user_constraintS
where table_name in ('TEST');

--2.DML:데이터조작어
-- 데이터 삽입 : insert
-- 데이터 변경 : update
-- 데이터 삭제 : delete

--9).데이터 삽입
id     password     name     gender     age     address
yang1    !1111      양영석      'M'       25       구미시
yoon2    @2222      윤호섭      'M'       19      대구광역시
lee3     #3333      이수광      'M'       30      서울특별시
an4      $4444      안여진      'F'       24      부산광역시

insert into test values ('yang1', '!1111', '양영석', 'M', 25, '구미시');--default값('M')이 있어도 직접적으로 적어줘도됨
insert into test values ('yoon2', '@2222', '윤호섭', default, 19, '대구광역시');--default값('M')이 있으므로 default 적어야함. 안적을시 오류
insert into test values ('lee3', '#3333', '이수광', default, 30, '서울특별시');
insert into test values ('an4', '$4444', '안여진', 'F', 24, '부산광역시');--default값이 ('M')이므로 'F'로 변경

--데이터 추가 확인
select *
from test;

--10).데이터 삭제
delete test;--테이블안의 모든 데이터를 삭제

--데이터 삭제 확인
select *
from test;

--11).'광역시'->'시'로 변경
--substr(기존문자열, 시작위치, 추출할개수) : 문자열의 일부만 추출한 문자열
--시작위치 : 음수면 문자열의 마지막을 기준으로 뒤에서 시작
--오라클 인덱스(index) : 1, 2, 3, .... (자바 인덱스 : 0, 1, 2, ....)
--방법1.substr
update test
set address = (substr(address,1,2)||substr(address,-1,1))--set address = (substr(address,1,2)||'시') 로 해도됨
where address like '%광역시';

--방법2.concat
update test
set address = concat(substr(address,1,2), substr(address,-1,1))--위 방법의 '||' 대신 concat을 사용한 경우. 
--																  마찬가지로 set address = concat(substr(address,1,2), '시') 로 해도됨
where address like '%광역시';

--방법3.replace
update test
set address = replace(address,'광역시','시')--'광역시' 를 찾아서 '시' 로 바꿈
where address like '%광역시';

--데이터 변경 확인
select *
from test;

--12).나이가 20미만인 데이터 삭제
delete test
where age < 20;

--데이터 삭제 확인
select *
from test;

--13).데이터 입력한 후 영구저장(트랜젝션 완료)->결과 확인(RUN SQL~에서 실행)
id     password     name     gender     age     address
jun5    %5555       전상호      'M'       28       null

insert into test values ('jun5', '%5555', '전상호', default, 28, null);
commit;

--데이터 입력 확인
select *
from test;

--14).데이터 삭제 후 이전 상태로 복귀 (트랜젠션 취소)->결과 확인(RUN SQL~에서 실행)
--주소가 '구미시'인 데이터 삭제
delete test
where address='구미시';

rollback;

--데이터 복구 확인
select *
from test;

--15).사용자가 소유한 테이블 이름 조회 -- 8장 참조
select table_name
from user_constraintS;

--16).테이블 구조 확인 (RUN SQL~에서 실행)
desc test;

--17).index 생성(index 명 : name_idx) ★primary key는 인덱스 자동생성
create index name_idx--create(생성) index(인덱스) name_idx(인덱스명)
on test(name);--on(위치) test(테이블명)(name(컬럼명))

--index 생성확인
select index_name
from user_ind_columnS
where index_name = 'NAME_IDX';

--18).view 생성(view 이름 : viewtest) 보안을 위해 가상테이블을 생성해 보여줌.
create view viewtest
as
select id, name, gender -- 개발자 생각에 보안이 필요한 컬럼은 제외하고 보여줄 항목만 넣는다.
from test;

--생성 확인
select *
from viewtest;

--19).실습을 위해 test2 테이블 생성 -> 데이터추가 -> inner join(=내부결합)
테이블명 - test
컬럼 - 필드           타입              null         key        default 
      id        varchar2(20)          no           PK          null
     major      varchar2(30)          yes                      null
--test2 테이블 생성
create table test2(
id varchar2(20) primary key,--primary key는 null값 허용하지 않기때문에 not null 적을 필요가 없다.
major varchar2(20)
);

--생성 확인(구조만 확인하기 위해선 RUN SQL~에서 desc test2;사용)
select *
from test2;

--데이터 추가
insert into test2 values ('yang1', '컴퓨터 공학');
insert into test2 values ('lee3', '건축 공학');
insert into test2 values ('an4', '환경 공학');
insert into test2 values ('jun5', '화학 공학');

--데이터 추가 확인
select *
from test2;

--inner join(id를 기준으로)
--방법1. natural join
select *
from test natural join test2;

--방법2.equi join
select *
from test t1, test2 t2
where t1.id=t2.id;

--방법3.join on
select *
from test t1 join test2 t2
on t1.id=t2.id;

--방법4.join using
select *
from test join test2
using (id);
--방법 1,4의 결과가 제일 깔끔하고 방법1이 제일 쓰기 간결함

--20).서브쿼리를 이용하여 major가 '컴퓨터 공학'인 사람의 이름 조회
--이름은 test테이블, test2테이블에는 id와 major밖에 없다.
--[1]major가 '컴퓨터 공학'인 사람 id조회
select id
from test2
where major='컴퓨터 공학';

--[2]서브쿼리로 결합
select name
from test
where id in (select id
			 from test2
			 where major='컴퓨터 공학');--결과가 하나이기 때문에 in 대신 '=' 써도됨

--21).집합연산자 : 각 쿼리의 컬럼 개수와 데이터 타입이 일치해야함
--21-1).union : 각 쿼리의 결과의 합을 반환하는 '합집합'(중복제거)
--				쿼리의 결과를 합치고 중복을 제거하는 작업이 추가로 적용되므로 쿼리의 속도 저하 및 부하가 발생.
--				중복을 제거할 필요가 없다면 union all을 사용하는것이 좋다.
--급여가 1200이상인 사원의 직업과 부서번호
--☆중복 확인을 위해 ename을 임의로 붙임
--☆ename을 뺀다는 가정하에. job과 dno 둘 다 같은것을 중복제거해준다.
select job, dno, ename
from employee
where salary >= 1200;--결과 5개

--부서번호가 10인 사원의 직업과 부서번호
select job, dno, ename
from employee
where dno = 10;--결과 3개

--위 두개의 결과를 합침(중복 제거)
select job, dno, ename
from employee
where salary >= 1200
union
select job, dno, ename
from employee
where dno = 10;

--21-2).union all(중복허용)
select job, dno, ename
from employee
where salary >= 1200
union all
select job, dno, ename
from employee
where dno = 10;

--21-3).intersect : 각 쿼리의 결과 중 같은 결과만 반환하는 '교집합'
--★예)a결과 = 1,2,3 
--    b결과 = 3,4,5
---------------------------
--    합집합 = 1,2,3,4,5
--    교집합 = 3
--    차집합(a-b) = 1,2
--    차집합(b-a) = 4,5

select job, dno, ename
from employee
where salary >= 1200
intersect
select job, dno, ename
from employee
where dno = 10;

--21-4).minus : 앞 쿼리의 결과 - 뒷 쿼리의 결과를 반환하는 '차집합'(중복 제거=차집합이니 당연히 중복이 제거된다.)
select job, dno, ename
from employee
where salary >= 1200
minus
select job, dno, ename
from employee
where dno = 10;--앞 쿼리 결과 5개에 뒷 쿼리 결과 3개 중 앞 쿼리에 곂치는것을 빼고 뒷 쿼리 결과에서 앞 쿼리 결과와 안곂치는것은 버림.

select job, dno, ename
from employee
where dno = 10
minus
select job, dno, ename
from employee
where salary >= 1200;--앞 쿼리 결과 3개에 뒷 쿼리 결과 5개 중 앞 쿼리에 곂치는것을 뺌 뒷 쿼리 결과에서 앞 쿼리 결과와 안곂치는것은 버림.

---------------------------------------------이 위 까지 내부평가 문제---------------------------------------------

------------union 특징들의 예------------
--예)같은 테이블의 다른 컬럼을 합쳐서 조회
--☆쿼리1에는 직업별로 그룹을 지어 직업별 급여총합을 구하고 쿼리2에는 직업별로 그룹을 지어 직업별 커미션 총합을 구한 후 합치시오
select 's1' as sal_type,
e1.job as job, --직업별 그룹
sum(e1.salary) as total_sal --직업별 급여 총합
from employee e1
group by e1.job
union all
select 's2' as sal_type,
e2.job as job,--직업별 그룹
sum(e2.commission) as total_comm--직업별 커미션 총합
from employee e2
group by e2.job;

--예)변형1
--두번째 쿼리문 부터는 별칭 생략 가능
--이유? 첫번째 쿼리문에 별칭을 사용하므로 같은 데이터기때문에 첫번째 쿼리문 별칭으로 자동으로 들어간다.
select 's1' as sal_type,
e1.job as job, --직업별 그룹
sum(e1.salary) as total_sal --직업별 급여 총합
from employee e1
group by e1.job
union all
select 's2',
e2.job,--직업별 그룹
sum(e2.commission)--직업별 커미션 총합
from employee e2
group by e2.job
order by job asc, sal_type desc;--asc생략가능. 쿼리문의 마지막에 1번만 정렬사용가능. 별칭,컬럼순번만 사용가능

--★  asc:오름차순(작은 수 부터 큰 수 or a 부터 z)
--  desc:내림차순(큰 수 부터 작은 수 or z 부터 a)

--예)변형2
--모든 별칭 생략하면 첫번째 쿼리문의 컬럼 자체가 컬럼명으로 표시됨
select 's1',
job, --직업별 그룹
sum(salary) --직업별 급여 총합
from employee
group by job
--order by 2 asc, 1 desc;--order by(=정렬)는 쿼리문의 마지막에 1번만 사용가능.
union all
select 's2',
job,--직업별 그룹
sum(commission)--직업별 커미션 총합
from employee
group by job
order by 2 asc, 1 desc;--컬럼 순번으로 정렬
--order by job asc, 's1' desc; --★'s1'은 별칭이 아니므로 사용 불가능.오류

--예2)다른 테이블의 같은 컬럼을 합쳐서 조회
--☆사원테이블과 부서테이블을 결합하여 부서번호와 부서이름을 조회(중복 제외)
select distinct dno, dname
from employee natural join department;

--☆부서테이블에서 부서번호와 부서이름을 조회, 하지만 부서번호에 속해 있는 사원테이블의 데이터가 존재하면 제외하고 존재하지않으면 출력한다.
--방법1
select dno, dname
from department d
where not exists(select *
				 from employee e
				 where e.dno=d.dno);--부서번호 40에 속한 사원테이블의 데이터가 존재하지않으니 부서번호 40만 출력하고 존재하는 10,20,30번 부서 제외
				 
--방법2
select dno, dname
from department--모든 부서에서
minus
select distinct dno, dname
from employee natural join department;--10,20,30번 부서 제외 -- natural join 자체가 employee의 부서번호에 데이터가 없으면 제외하고 조인하기때문

--☆부서테이블에서 부서번호와 부서이름을 조회, 하지만 부서번호에 속해 있는 사원테이블의 데이터가 존재하지않으면 제외하고 존재하면 출력한다.
select dno, dname
from department d
where exists(select *
			 from employee e
			 where e.dno=d.dno)
order by 1;--부서번호 40에 속한 사원테이블의 데이터가 존재하지않으니 부서번호 40을 제외하고 존재하는 10,20,30번 부서 출력

--위 쿼리문들을 사용하기
--union을 사용하여 쿼리결과를 합치시오 - 합집합
select distinct dno, dname
from employee natural join department--10,20,30번 부서
union all
select dno, dname
from department d
where not exists(select *
				 from employee e
				 where e.dno=d.dno);--40번 부서
--union은 중복제외 union all은 중복허용이나 중복되는 값이 없어서 둘 중 아무거나 사용해도됨

--차집합 - 40번부서만 출력하기
select dno, dname
from department--모든 부서에서
minus
select distinct dno, dname
from employee natural join department;--10,20,30번 부서 제외

--예3)합계를 따로 연산하여 조회결과에 합치는 용도
select job, sum(salary) as total_sal
from employee
group by job--그룹별 사원의 급여 총합
union all
select '합계', sum(salary)
from employee;--모든 사원의 급여 총합

--예3)연봉 상위 3명 조회
--방법1-union all 사용
select *
from (select ename, salary
	  from employee
	  where dno=10
	  union all
	  select ename, salary
	  from employee
	  where dno=20
	  union all
	  select ename, salary
	  from employee
	  where dno=30
	  order by 2 desc, 1)--정렬 급여순으로 안할 시 결과 이상하게 나옴. where절에서 결과 맨 위 3줄만 출력하게 했기때문에 
--							그래서 급여순 내림차순 정렬해야 높은 급여가 위로가기때문에 위에서 3줄 즉 상위3명만 출력할수있다.
where rownum < 4;--결과 줄 4개 밑으로만 출력하라.(=3줄 출력)
--union all은 무한대로 사용할수 있다는 것을 보여주기 위한 예이다.

--위 예의 잘못된 사용법
select ename, salary
from employee --이 결과의 출력된 순서는 입력된 순서
where rownum < 4 --문법상 검색조건이 여기에 들어가고 정렬이 밑에들어가는데
order by 2 desc, 1;--지금 이 순서로 쿼리문 실행시 모든 사원의 급여 출력 후 맨 위 3명을 뽑은 후 그 3명의 급여를 정렬하게 되므로 값이 다르다.(입력된 순서대로 맨 위 3명을 뽑게됨)

--방법2-rank() 함수 사용
select ename, salary, rank() over(order by salary desc) as "급여 순위"
from employee;
--where rownum<4; where절에 상위3명만 출력하기위한 코드를 적을 시 랭크함수로 순위매긴것 기준으로 상위3명 출력하는것이아닌 입력기준으로 상위3명 출력함. 아래 방법2-1, 2-2 둘다 마찬가지
--이 쿼리문(where절포함)은 where절 먼저 진행 후 랭크함수가 들어가므로 작업수행순서가 잘못되어 값이 안나온다.

--★이 결과에서 상위3명 뽑을수있는 방법 알아내기
select *
from (select ename, salary, rank() over(order by salary desc) as "급여 순위"
	  from employee)
where rownum < 4;--이런식으로 작업수행순서를 바꾸어 진행하면 값이 나온다.

--만약 방법 2에 중복된 등수가 있다면? ex) 1등 salary=1800은 1명 2등 salary=1370은 3명 3등 salary=1300은 2명 일 경우
--지금 나의 데이터에는 9등인 급여1100을 받는 사원이 3명으로 중복됨
--방법2-1
select ename, salary, commission,
rank() over(order by salary desc) as "급여 순위-1",--8,9,9,9,12 나옴
dense_rank() over(order by salary desc) as "급여 순위-2",--8,9,9,9,10 으로됨 --dense는 동일한 순위를 하나의 건수로 취급(=하나의 순위로 취급)
rank() over(order by salary desc, commission desc) as "급여 순위-3" --급여가 같다면 순위가 중복되지 않도록 하기위해 커미션이 높은 사람을 위로 올려 중복을 제거한다 -> 8,9,10,11,12
from employee;

--방법2-2
--row_number() 함수 사용
select ename, salary,
row_number() over(order by salary desc) as "급여 순위"
from employee; --자동으로 중복을 제거하여 8,9,10,11,12로 나옴 무엇을 기준으로 중복을 나눈건지는 모르겠음
--		찾아보니 eno(employee의 맨 처음 생성한 컬럼이자 primary key)를 오름차순정렬하여 2차 기준으로 잡은거같음

--★★인덱스, 뷰, 제약조건 검색 시 where절에 들어가는것에 따른 조건(대,소문자 쓰는법)
--간단하게 제약조건을 기준으로 함.

--in을 사용시 ()안에 대문자로 표시해야함.
select *
from user_constraintS --인덱스 : user_idx_columnS or user_indexES
					  --user_idx_columS : 테이블안의 컬럼에대한것 까지 표시
					  --user_indexES : 테이블안의 인덱스에 대한것만 표시. indexES를 사용시 컬럼에 관한것은 출력하지 못한다.
where table_name in ('TEST'); --뷰 : 뷰는 가상테이블이므로 테이블네임에 기재해야함 ex)where table_name in('VIEWTEST')

--lower(컬럼명) 후 in을 사용시 ()안에 소문자로 표시해야함
select *
from user_constraintS
where lower(table_name) in ('test');

--=을 사용시 대문자로 표시해야함
select *
from user_constraintS
where table_name = 'TEST';

--lower(컬럼명) 후 =을 사용시 소문자로 표시해야함
select *
from user_constraintS
where lower(table_name) = 'test';

--정리 : lower(컬럼명)을 사용 후 = 나 in을 사용하면 소문자
--      lower(컬럼명)을 사용하지않고 = 나 in을 사용하면 대문자.
--★in안에는 여러개 들어갈수있고, =안에는 1개만 들어간다.

/**************************************************************************************************************************************/