----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2026 22:41:45
-- Design Name: 
-- Module Name: demultiplexer - Behavioral
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

entity demultiplexer is
    Port ( sel_code : in STD_LOGIC_VECTOR (3 downto 0);
           cs_empty_nonOpen : out STD_LOGIC;
           cs_empty_open : out STD_LOGIC;
           cs_1 : out STD_LOGIC;
           cs_2 : out STD_LOGIC;
           cs_bomb : out STD_LOGIC;
           cs_3 : out STD_LOGIC;
           cs_4: out std_logic;
           cs_5 : out STD_LOGIC;
           cs_6: out std_logic;
           cs_7 : out STD_LOGIC;
           cs_8: out std_logic);
end demultiplexer;

architecture Behavioral of demultiplexer is

begin

process(sel_code)
begin
    cs_empty_nonOpen <= '0';
    cs_empty_open    <= '0';
    cs_1             <= '0';
    cs_2             <= '0';
    cs_3             <= '0';
    cs_bomb          <= '0';
    cs_4             <= '0';
    cs_5             <= '0';
    cs_6             <= '0';
    cs_7             <= '0';
    cs_8             <= '0';
        case sel_code is
            when "0000" => cs_empty_open    <= '1';
            when "0001" => cs_1             <= '1';
            when "0010" => cs_2             <= '1';
            when "0011" => cs_3             <= '1';
            when "0100" => cs_4             <= '1';
            when "0101" => cs_5             <= '1';
            when "0110" => cs_6             <= '1';
            when "0111" => cs_7             <= '1';
            when "1000" => cs_8             <= '1';
            when "1001" => cs_bomb          <= '1';
            when "1010" => cs_empty_nonOpen <= '1';
            when others => null;
    end case;
end process;
end Behavioral;
