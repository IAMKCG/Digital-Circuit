library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lab3 is
Port (
	clk : IN STD_LOGIC;
	rst : IN STD_LOGIC;
	en : IN STD_LOGIC;
	upc : IN STD_LOGIC;
	dnc : IN STD_LOGIC;
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
signal havereset : STD_LOGIC := '0';

begin
	process(clk, en, upc, dnc, rst)
	variable n_cnt, t_cnt_1, t_cnt_2 : integer := 0;
	begin
		if (havereset = '0' and rst = '0') then
			cnt <= 0;
			havereset <= '1';
		end if;
		if (havereset = '1' and rst = '1') then
			havereset <= '0';
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
			
		if (en = '1') then
			if (upc = '1' and dnc ='0') then
				if (cnt < 63) then
					n_cnt := cnt + 1;
				elsif (cnt = 63) then
					n_cnt := 0;
				end if;
			elsif (upc = '0' and dnc = '1') then
				if (cnt > 0) then
					n_cnt := cnt - 1;
				elsif (cnt = 0) then
					n_cnt := 63;
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
