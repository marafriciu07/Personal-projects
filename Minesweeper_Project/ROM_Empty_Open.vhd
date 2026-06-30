----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2026 18:05:09
-- Design Name: 
-- Module Name: ROM_Empty_Open - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROM_Empty_Open is
    Port ( address : in STD_LOGIC_VECTOR (2 downto 0);
           cs : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end ROM_Empty_Open;

architecture Behavioral of ROM_Empty_Open is

begin
process(address, cs)
begin
if cs = '1' then
case address is
when others => data_out <="00000000";
end case;
else data_out <= "00000000"; 
end if;
end process;


end Behavioral;
