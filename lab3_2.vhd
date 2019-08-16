library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lab3 is
Port (
	clk : IN STD_LOGIC;
	rst_in : IN STD_LOGIC;
	en_in : IN STD_LOGIC;
	upc_in : IN STD_LOGIC;
	dnc_in : IN STD_LOGIC;
	stepadd_in : IN STD_LOGIC;
	stepmis_in : IN STD_LOGIC;
	clk_bps : INOUT STD_LOGIC := '0';
	clk_mps : INOUT STD_LOGIC := '0';
	bcdout : OUT STD_LOGIC_VECTOR (0 TO 6)
);
end lab3;

architecture Behavioral of lab3 is

signal out1, out2 : STD_LOGIC_VECTOR(0 TO 6);
signal cnt: integer := 0;
signal time_cnt_1 : integer := 0;
signal time_cnt_2 : integer := 0;
signal step : integer := 1;
signal rst, upc, en, dnc, stepadd, stepmis : STD_LOGIC := '0';
signal up, enb, dn : STD_LOGIC := '0';
signal tc_up, tc_dn, tc_en, tc_sa, tc_sm, tc_rs : integer := 0;

begin
	process(clk, rst_in, en_in, upc_in, dnc_in, stepadd_in, stepmis_in)
	variable t1, t2, t3, t4, t5, t6 : integer := 0;
	begin
		t1 := tc_up; t2 := tc_dn; t3 := tc_en; t4 := tc_sa; t5 := tc_sm; t6 := tc_rs;
		if (clk = '1' and clk'event) then

			if (upc_in = '1') then
				if (t1 <= 50000) then
					t1 := t1 + 1;
				end if;
				if (t1 = 50000) then
					upc <= '1';
				else
					upc <= '0';
				end if;
			else
				t1 := 0;
				upc <= '0';
			end if;

			if (dnc_in = '1') then
				if (t2 <= 50000) then
					t2 := t2 + 1;
				end if;
				if (t2 = 50000) then
					dnc <= '1';
				else
					dnc <= '0';
				end if;
			else
				t2 := 0;
				dnc <= '0';
			end if;

			if (en_in = '1') then
				if (t3 <= 50000) then
					t3 := t3 + 1;
				end if;
				if (t3 = 50000) then
					en <= '1';
				else
					en <= '0';
				end if;
			else
				t3 := 0;
				en <= '0';
			end if;

			if (stepadd_in = '1') then
				if (t4 <= 50000) then
					t4 := t4 + 1;
				end if;
				if (t4 = 50000) then
					stepadd <= '1';
				else
					stepadd <= '0';
				end if;
			else
				t4 := 0;
				stepadd <= '0';
			end if;

			if (stepmis_in = '1') then
				if (t5 <= 50000) then
					t5 := t5 + 1;
				end if;
				if (t5 = 50000) then
					stepmis <= '1';
				else
					stepmis <= '0';
				end if;
			else
				t5 := 0;
				stepmis <= '0';
			end if;

			if (rst_in = '1') then
				if (t6 <= 50000) then
					t6 := t6 + 1;
				end if;
				if (t6 = 50000) then
					rst <= '1';
				else
					rst <= '0';
				end if;
			else
				t6 := 0;
				rst <= '0';
			end if;

		end if;
		tc_up <= t1; tc_dn <= t2; tc_en <= t3; tc_sa <= t4; tc_sm <= t5; tc_rs <= t6;

	end process;

	process(clk, upc, dnc, en, rst, stepadd, stepmis)
	begin
		if (clk = '1' and clk'event) then
			if (upc = '1') then
				up <= '1';
				dn <= '0';
				enb <= '1';
			end if;
			if (dnc = '1') then
				up <= '0';
				dn <= '1';
				enb <= '1';
			end if;
			if (en = '1') then
				enb <= '0';
			end if;
			if (rst = '1') then
				up <= '0';
				dn <= '0';
				enb <= '0';
				step <= 1;
			end if;
			if (stepadd = '1') then
				if (step = 1) then
					step <= 2;
				elsif (step =2) then
					step <= 4;
				end if;
			end if;
			if (stepmis = '1') then
				if (step = 4) then
					step <= 2;
				elsif (step = 2) then
					step <= 1;
				end if;
			end if;
		end if;
	end process;

	process(clk, enb, rst)
	variable n_cnt, t_cnt_1, t_cnt_2 : integer := 0;
	begin
		if (rst = '1') then
			cnt <= 0;
		end if;
		if (time_cnt_1 < 200000000) then
			t_cnt_1 := time_cnt_1 + 1;
		elsif (time_cnt_1 = 200000000) then
			t_cnt_1 := 0;
		end if;
		
		if (time_cnt_2 < 1000000) then
			t_cnt_2 := time_cnt_2 + 1;
		elsif (time_cnt_2 = 1000000) then
			t_cnt_2 := 0;
		end if;
		
		if (enb = '1') then
			if (up = '1' and dn ='0') then
				if (cnt + step < 63 or cnt + step = 63) then
					n_cnt := cnt + step;
				else
					n_cnt := cnt + step - 64;
				end if;
			elsif (up = '0' and dn = '1') then
				if (cnt - step >= 0) then
					n_cnt := cnt - step;
				else
					n_cnt := 64 + cnt - step;
				end if;
			else n_cnt := cnt;
			end if;
		else
			n_cnt := cnt;
		end if;

		if (time_cnt_2 < 500000) then 
	    	clk_mps <= '0'; clk_bps <= '1';
		else
	   		clk_mps <= '1'; clk_bps <= '0';
		end if;
		
		if (clk'event and clk = '1') then
			time_cnt_1 <= t_cnt_1;
			time_cnt_2 <= t_cnt_2;
			if (time_cnt_2 < 500000) then 
	    		clk_mps <= '0'; clk_bps <= '1';
			else
	   			clk_mps <= '1'; clk_bps <= '0';
			end if;
			if (time_cnt_1 = 200000000) then
				cnt <= n_cnt;
			end if;
		end if;

	end process;

out2 <= "1111110" when cnt = 0 else
		"0110000" when cnt = 1 else
		"1101101" when cnt = 2 else
		"1111001" when cnt = 3 else
		"0110011" when cnt = 4 else
		"1011011" when cnt = 5 else
		"1011111" when cnt = 6 else
		"1110000" when cnt = 7 else
		"1111111" when cnt = 8 else
		"1111011" when cnt = 9 else
		"1111110" when cnt = 10 else
		"0110000" when cnt = 11 else
		"1101101" when cnt = 12 else
		"1111001" when cnt = 13 else
		"0110011" when cnt = 14 else
		"1011011" when cnt = 15 else
		"1011111" when cnt = 16 else
		"1110000" when cnt = 17 else
		"1111111" when cnt = 18 else
		"1111011" when cnt = 19 else
		"1111110" when cnt = 20 else
		"0110000" when cnt = 21 else
		"1101101" when cnt = 22 else
		"1111001" when cnt = 23 else
		"0110011" when cnt = 24 else
		"1011011" when cnt = 25 else
		"1011111" when cnt = 26 else
		"1110000" when cnt = 27 else
		"1111111" when cnt = 28 else
		"1111011" when cnt = 29 else
		"1111110" when cnt = 30 else
		"0110000" when cnt = 31 else
		"1101101" when cnt = 32 else
		"1111001" when cnt = 33 else
		"0110011" when cnt = 34 else
		"1011011" when cnt = 35 else
		"1011111" when cnt = 36 else
		"1110000" when cnt = 37 else
		"1111111" when cnt = 38 else
		"1111011" when cnt = 39 else
		"1111110" when cnt = 40 else
		"0110000" when cnt = 41 else
		"1101101" when cnt = 42 else
		"1111001" when cnt = 43 else
		"0110011" when cnt = 44 else
		"1011011" when cnt = 45 else
		"1011111" when cnt = 46 else
		"1110000" when cnt = 47 else
		"1111111" when cnt = 48 else
		"1111011" when cnt = 49 else
		"1111110" when cnt = 50 else
		"0110000" when cnt = 51 else
		"1101101" when cnt = 52 else
		"1111001" when cnt = 53 else
		"0110011" when cnt = 54 else
		"1011011" when cnt = 55 else
		"1011111" when cnt = 56 else
		"1110000" when cnt = 57 else
		"1111111" when cnt = 58 else
		"1111011" when cnt = 59 else
		"1111110" when cnt = 60 else
		"0110000" when cnt = 61 else
		"1101101" when cnt = 62 else
		"1111001" when cnt = 63 else
		"ZZZZZZZ";
out1 <= "1111110" when cnt = 0 else
		"1111110" when cnt = 1 else
		"1111110" when cnt = 2 else
		"1111110" when cnt = 3 else
		"1111110" when cnt = 4 else
		"1111110" when cnt = 5 else
		"1111110" when cnt = 6 else
		"1111110" when cnt = 7 else
		"1111110" when cnt = 8 else
		"1111110" when cnt = 9 else
		"0110000" when cnt = 10 else
		"0110000" when cnt = 11 else
		"0110000" when cnt = 12 else
		"0110000" when cnt = 13 else
		"0110000" when cnt = 14 else
		"0110000" when cnt = 15 else
		"0110000" when cnt = 16 else
		"0110000" when cnt = 17 else
		"0110000" when cnt = 18 else
		"0110000" when cnt = 19 else
		"1101101" when cnt = 20 else
		"1101101" when cnt = 21 else
		"1101101" when cnt = 22 else
		"1101101" when cnt = 23 else
		"1101101" when cnt = 24 else
		"1101101" when cnt = 25 else
		"1101101" when cnt = 26 else
		"1101101" when cnt = 27 else
		"1101101" when cnt = 28 else
		"1101101" when cnt = 29 else
		"1111001" when cnt = 30 else
		"1111001" when cnt = 31 else
		"1111001" when cnt = 32 else
		"1111001" when cnt = 33 else
		"1111001" when cnt = 34 else
		"1111001" when cnt = 35 else
		"1111001" when cnt = 36 else
		"1111001" when cnt = 37 else
		"1111001" when cnt = 38 else
		"1111001" when cnt = 39 else
		"0110011" when cnt = 40 else
		"0110011" when cnt = 41 else
		"0110011" when cnt = 42 else
		"0110011" when cnt = 43 else
		"0110011" when cnt = 44 else
		"0110011" when cnt = 45 else
		"0110011" when cnt = 46 else
		"0110011" when cnt = 47 else
		"0110011" when cnt = 48 else
		"0110011" when cnt = 49 else
		"1011011" when cnt = 50 else
		"1011011" when cnt = 51 else
		"1011011" when cnt = 52 else
		"1011011" when cnt = 53 else
		"1011011" when cnt = 54 else
		"1011011" when cnt = 55 else
		"1011011" when cnt = 56 else
		"1011011" when cnt = 57 else
		"1011011" when cnt = 58 else
		"1011011" when cnt = 59 else
		"1011111" when cnt = 60 else
		"1011111" when cnt = 61 else
		"1011111" when cnt = 62 else
		"1011111" when cnt = 63 else
		"ZZZZZZZ"; 

bcdout<=out2 when clk_mps='1' else
		out1 when clk_bps='1' else
		"ZZZZZZZ";

end Behavioral; 
