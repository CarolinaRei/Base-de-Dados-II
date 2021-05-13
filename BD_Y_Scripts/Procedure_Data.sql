create or replace procedure etl_date
is

begin
    for month in 1..12 loop
        for day in 1..to_char(last_day(sysdate), 'dd') loop
            insert into date(id, day, month, year, month_name, day_week, day_week_name)
        end loop;
    end loop;
end;