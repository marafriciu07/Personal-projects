----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2026 06:38:00 PM
-- Design Name: 
-- Module Name: ROM_Bomb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROM_Bomb is
    Port ( address : in STD_LOGIC_VECTOR (2 downto 0);
           cs : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end ROM_Bomb;

architecture Behavioral of ROM_Bomb is
type memory_type is array(0 to 7) of std_logic_vector(7 downto 0);
signal memo_map : memory_type := (0=>"00100100",
                                  1=>"00011000",
                                  2=>"01111110",
                                  3=>"11111111",
                                  4=>"11111111",
                                  5=>"01111110",
                                  6=>"00011000",
                                  7=>"00100100",
                                  others=>"00000000");
begin
data_out <= memo_map(conv_integer(address)) when cs='1' else "00000000";


end Behavioral;