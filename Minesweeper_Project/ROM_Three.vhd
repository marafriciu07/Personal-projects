----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2026 18:58:02
-- Design Name: 
-- Module Name: ROM_Three - Behavioral
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

entity ROM_Three is
    Port ( address : in STD_LOGIC_VECTOR (2 downto 0);
           cs : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end ROM_Three;

architecture Behavioral of ROM_Three is
type memory_type is array (0 to 7) of std_logic_vector(7 downto 0);
signal memo_map : memory_type := (0=>"00000000",
                                  1=>"00111100",
                                  2=>"01000010",
                                  3=>"00000010",
                                  4=>"00011100",
                                  5=>"00000010",
                                  6=>"01000010",
                                  7=>"00111100",
                                  others=>"00000000");
begin
data_out<= memo_map (conv_integer(address)) when cs='1' else "00000000";
end Behavioral;
