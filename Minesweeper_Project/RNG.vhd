----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2026 14:19:51
-- Design Name: 
-- Module Name: random_number_generator - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RNG is
    Port ( clk : in STD_LOGIC;
           mode : in STD_LOGIC_VECTOR (1 downto 0);
           seed : in STD_LOGIC_vECTOR (5 downto 0);
           q_out : out STD_LOGIC_VECTOR (5 downto 0));
end RNG;

architecture Behavioral of RNG is

signal reg_state : STD_LOGIC_VECTOR(5 downto 0);

begin

process(clk)
begin
    if rising_edge(clk) then
            case mode is
                when "11" => reg_state <= seed;
                when "01" =>  -- shift right + feedback XOR
                    reg_state <= (reg_state(5) xor reg_state(0)) & reg_state(5 downto 1);
                when others => null;
            end case;
    end if;
end process;
q_out <= reg_state;
end Behavioral;
