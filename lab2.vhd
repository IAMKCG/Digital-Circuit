library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lab2 is
Port (
	clk : IN STD_LOGIC;
	rst : IN STD_LOGIC;
	clk_bps : INOUT STD_LOGIC:='0';
	clk_mps : INOUT STD_LOGIC:='0';
	seg : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	bcdout : OUT STD_LOGIC_VECTOR(0 TO 6)	
);
end lab2;

architecture Behavioral of lab2 is
signal out1, out2 : STD_LOGIC_VECTOR(0 TO 6);
signal cnt: integer :=0;
begin
out2 <= "1111110" when seg = "0000" else
	"0110000" when seg = "0001" else
	"1101101" when seg = "0010" else
	"1111001" when seg = "0011" else
	"0110011" when seg = "0100" else
	"1011011" when seg = "0101" else
	"1011111" when seg = "0110" else
	"1110000" when seg = "0111" else
	"1111111" when seg = "1000" else
	"1111011" when seg = "1001" else
	"1111110" when seg = "1010" else
	"0110000" when seg = "1011" else
	"1101101" when seg = "1100" else
	"1111001" when seg = "1101" else
	"0110011" when seg = "1110" else
	"1011011" when seg = "1111" else
	"ZZZZZZZ";
out1 <= "1111110" when seg = "0000" else
	"1111110" when seg = "0001" else
	"1111110" when seg = "0010" else
	"1111110" when seg = "0011" else
	"1111110" when seg = "0100" else
	"1111110" when seg = "0101" else
	"1111110" when seg = "0110" else
	"1111110" when seg = "0111" else
	"1111110" when seg = "1000" else
	"1111110" when seg = "1001" else
	"0110000" when seg = "1010" else
	"0110000" when seg = "1011" else
	"0110000" when seg = "1100" else
	"0110000" when seg = "1101" else
	"0110000" when seg = "1110" else
	"0110000" when seg = "1111" else
	"ZZZZZZZ"; 


process(clk, rst)
variable n_cnt : integer := 0;
begin
	if (cnt < 1000000) then
	   n_cnt := cnt + 1;
	elsif (cnt = 1000000) then
	   n_cnt := 0;
	end if;
	
	if (cnt < 500000) then 
	   clk_mps<='0';clk_bps<='1';
	else
	   clk_mps<='1';clk_bps<='0';
    end if;
    
	if (clk'event and clk='1') then
	   if (rst='0') then
	       cnt <= 0;
	   else
	       cnt <= n_cnt;
	       if (n_cnt < 500000) then 
	           clk_mps<='0';clk_bps<='1';
	       else
	           clk_mps<='1';clk_bps<='0';
	       end if;
	   end if;
	end if;
	
end process;

bcdout<=out2 when clk_mps='1' else
	out1 when clk_bps='1' else
	"ZZZZZZZ";

end Behavioral; 
