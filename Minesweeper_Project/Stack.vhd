----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.04.2026 17:00:36
-- Design Name: 
-- Module Name: Stack - Behavioral
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

entity Stack is
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           push : in STD_LOGIC;
           pop : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (5 downto 0);
           data_out : out STD_LOGIC_VECTOR (5 downto 0));
           
end Stack;

architecture Behavioral of Stack is

type stack_array is array (0 to 63) of STD_LOGIC_VECTOR(5 downto 0);
signal stack_memory : stack_array;

signal sp: integer range 0 to 64 := 0;
begin

process(clk, rst_n)
begin
if rst_n = '1' then
    sp <= 0;
    data_out <= (others => '0');
else
    if rising_edge(clk) then
        if push = '1' and sp < 64 then
            stack_memory(sp) <= data_in;
            sp <= sp + 1;
        end if;
  
        if pop = '1' and sp > 0 then
            data_out <= stack_memory(sp - 1);
            sp <= sp - 1;
        end if;
    end if;
end if;
end process;
end Behavioral;
