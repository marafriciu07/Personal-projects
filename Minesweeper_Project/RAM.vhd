----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2026 09:23:47 AM
-- Design Name: 
-- Module Name: RAM - Behavioral
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

entity RAM is
    Port ( address : in STD_LOGIC_VECTOR (5 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           we : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (3 downto 0);
           data_out : out STD_LOGIC_VECTOR (3 downto 0));
end RAM;

architecture Behavioral of RAM is
type ram_type is array (0 to 63) of std_logic_vector (3 downto 0);
signal ram: ram_type := (others => "1010"); --nonopen cell
begin
process(clk,reset)
begin
    if reset = '1' then 
        ram <= (others => "1010"); --nonopen cell
    elsif rising_edge(clk) then
        if we = '1' then
            ram(conv_integer(address)) <= data_in;
        end if;
    end if;
end process;
data_out <= ram(conv_integer(address));
end Behavioral;