----------------------------------------------------------------------------------
-- University of Mississippi El E 386
-- Lab 6 
-- Engineer: Ben Mighall
--
-- This program runs an "ALU"-type system that compares two 4-bit numbers from two sets of four switches
-- (Number A is switches 12-15; number B is switches 8-11), reads a 4-bit opcode from switches 0-3,
-- performs operations depending on switches 1 and 0 and displays the result based on switches 3 and 2.
-- The result is then displayed on a 7-segment display with a button serving as a clock: first segment displays input A
-- second segment displays input B, and the third and fourth segments display the final result.
-- 
-- Switch 1 and 0 digits (operations): 00 = add; 01 = subtract; 10 = and; 11 = or
-- Switch 4 and 3 digits (display): 00 = pass through (regular display); 01 = circulate left; 10 = circulate right; 11 = invert
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use IEEE.NUMERIC_STD.ALL;

entity ALUwith7seg is
    Port ( LED : out STD_LOGIC_VECTOR (5 downto 0);
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           SSEG_AN: out STD_LOGIC_VECTOR (7 downto 0);
           SSEG_CA: out STD_LOGIC_VECTOR (7 downto 0);
           BTN : in STD_LOGIC_VECTOR (4 downto 0));
end ALUwith7seg;

architecture Behavioral of ALUwith7seg is

signal temp: STD_LOGIC_VECTOR (4 downto 0);
signal output: STD_LOGIC_VECTOR (4 downto 0);

type state_type is (s0,s1,s2,s3);
signal current_state, next_state: state_type;

begin

P1:process(SW(3 downto 2), SW(1 downto 0), SW(15 downto 12), SW(11 downto 8))
begin
case SW(3 downto 2) is  
    --pass through
    when "00" =>
        case SW(1 downto 0) is 
			when "00" =>
               output (4 downto 0) <= ((SW(15 downto 12) + "00000") + (SW(11 downto 8) + "00000"));
            when "01" =>
               output (4 downto 0) <= ((SW(15 downto 12) - SW(11 downto 8)) + "00000");
            when "10" =>
               output (4 downto 0) <= ((SW(15 downto 12) AND SW(11 downto 8)) + "00000");
            when "11" =>
               output (4 downto 0) <= ((SW(15 downto 12) OR SW(11 downto 8)) + "00000");
        end case;
    --circ. left
    when "01" => 
       case SW(1 downto 0) is 
          when "00" =>
            temp(4 downto 0) <= (SW(15 downto 12) + "00000") + (SW(11 downto 8) + "00000");
            output(4 downto 0) <= (temp(3 downto 0) & temp(4)); 
          when "01" =>
            temp(4 downto 0) <= ((SW(15 downto 12) - SW(11 downto 8)) + "00000");
            output(4 downto 0) <= (temp(3 downto 0) & temp(4));                          
          when "10" =>
             temp(4 downto 0) <= ((SW(15 downto 12) AND SW(11 downto 8)) + "00000");
             output(4 downto 0) <= (temp(3 downto 0) & temp(4)); 
          when "11" =>
             temp(4 downto 0) <= ((SW(15 downto 12) OR SW(11 downto 8)) + "00000");
             output(4 downto 0) <= (temp(3 downto 0) & temp(4));           
        end case;
    --circ. right
    when "10" => 
	  case SW (1 downto 0) is 
		  when "00" =>
			 temp(4 downto 0) <= (SW(15 downto 12) + "00000") + (SW(11 downto 8) + "00000");
			 output(4 downto 0) <= (temp(0) & temp(4 downto 1)); 
		  when "01" =>
			 temp(4 downto 0) <= ((SW(15 downto 12) - SW(11 downto 8)) + "00000");
			 output(4 downto 0) <= (temp(0) & temp(4 downto 1));                          
		  when "10" =>
			 temp(4 downto 0) <= ((SW(15 downto 12) AND SW(11 downto 8)) + "00000");
			 output(4 downto 0) <= (temp(0) & temp(4 downto 1)); 
		  when "11" =>
			 temp(4 downto 0) <= ((SW(15 downto 12) OR SW(11 downto 8)) + "00000");
			 output(4 downto 0) <= (temp(0) & temp(4 downto 1));                           
		end case;
    --invert
    when "11" =>
	   case SW(1 downto 0) is 
		  when "00" =>
			 temp(4 downto 0) <= (SW(15 downto 12) + "00000") + (SW(11 downto 8) + "00000");
			 output(4 downto 0) <= NOT(temp(4 downto 0));
		  when "01" =>
			 temp(4 downto 0) <= ((SW(15 downto 12) - SW(11 downto 8)) + "00000");
			 output(4 downto 0) <= NOT(temp(4 downto 0));
		  when "10" =>
			 temp(4 downto 0) <= ((SW(15 downto 12) AND SW(11 downto 8)) + "00000");
			 output(4 downto 0) <= NOT(temp(4 downto 0));
		  when "11" =>
			 temp(4 downto 0) <= ((SW(15 downto 12) OR SW(11 downto 8)) + "00000");
			 output(4 downto 0) <= NOT(temp(4 downto 0));
	   end case;  
end case;
end process;

--display 1st number
P2:process(current_state, next_state, BTN(2))
begin
    if(BTN(2)'event and BTN(2)='1')then
        current_state <= next_state;    
    end if;
end process;

P3:process(current_state,next_state)
begin
case current_state is
	when s0 =>
		SSEG_AN <= "01111111";
		next_state <= s1;
		case SW(15 downto 12) is 
			--these are the seven-segment codes for hex digits, 0 through F
			 when "0000" => SSEG_CA <= "11000000";
			 when "0001" => SSEG_CA <= "11111001";
			 when "0010" => SSEG_CA <= "10100100";     
			 when "0011" => SSEG_CA <= "10110000";
			 when "0100" => SSEG_CA <= "10011001";
			 when "0101" => SSEG_CA <= "10010010";
			 when "0110" => SSEG_CA <= "10000010";
			 when "0111" => SSEG_CA <= "11111000";
			 when "1000" => SSEG_CA <= "10000000";    
			 when "1001" => SSEG_CA <= "10010000";
			 when "1010" => SSEG_CA <= "10001000";
			 when "1011" => SSEG_CA <= "10000011";
			 when "1100" => SSEG_CA <= "11000110";    
			 when "1101" => SSEG_CA <= "10100001";
			 when "1110" => SSEG_CA <= "10000110";
			 when "1111" => SSEG_CA <= "10001110";
		end case;
   when s1 =>     
		SSEG_AN <= "10111111";
		next_state <= s2;
		case SW(11 downto 8) is
			when "0000" => SSEG_CA <= "11000000";
			when "0001" => SSEG_CA <= "11111001";
			when "0010" => SSEG_CA <= "10100100";        
			when "0011" => SSEG_CA <= "10110000";
			when "0100" => SSEG_CA <= "10011001";
			when "0101" => SSEG_CA <= "10010010";
			when "0110" => SSEG_CA <= "10000010";
			when "0111" => SSEG_CA <= "11111000";
			when "1000" => SSEG_CA <= "10000000";     
			when "1001" => SSEG_CA <= "10010000";
			when "1010" => SSEG_CA <= "10001000";
			when "1011" => SSEG_CA <= "10000011";
			when "1100" => SSEG_CA <= "11000110";    
			when "1101" => SSEG_CA <= "10100001";
			when "1110" => SSEG_CA <= "10000110";
			when "1111" => SSEG_CA <= "10001110";                   
		end case;                                              
	when s2 =>
		SSEG_AN <= "11011111";
		next_state <= s3;
		if(output(4)='1') then
			SSEG_CA <= "11111001"; --1
		else 
			SSEG_CA <= "11000000"; --0        
		end if;
	when s3 =>
		SSEG_AN <= "11101111";
		next_state <= s0;        
		case output(3 downto 0) is
			when "0000" => SSEG_CA <= "11000000";
			when "0001" => SSEG_CA <= "11111001";
			when "0010" => SSEG_CA <= "10100100";       
			when "0011" => SSEG_CA <= "10110000";
			when "0100" => SSEG_CA <= "10011001";
			when "0101" => SSEG_CA <= "10010010";
			when "0110" => SSEG_CA <= "10000010";
			when "0111" => SSEG_CA <= "11111000";
			when "1000" => SSEG_CA <= "10000000";    
			when "1001" => SSEG_CA <= "10010000";
			when "1010" => SSEG_CA <= "10001000";
			when "1011" => SSEG_CA <= "10000011";
			when "1100" => SSEG_CA <= "11000110";    
			when "1101" => SSEG_CA <= "10100001";
			when "1110" => SSEG_CA <= "10000110";
			when "1111" => SSEG_CA <= "10001110";
		end case;
end case;
end process;

end Behavioral;