----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2026 17:27:31
-- Design Name: 
-- Module Name: Bomb_Generator - Behavioral
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

entity Bomb_Generator is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           rng_in : in STD_LOGIC_VECTOR (5 downto 0);
           done : out STD_LOGIC;
           bombs_flat : out STD_LOGIC_VECTOR (63 downto 0));
end Bomb_Generator;

architecture Behavioral of Bomb_Generator is

type state_type is (IDLE, GENERATED, FINISH);
signal state : state_type := IDLE;

signal bombs : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
signal bomb_count : INTEGER range 0 to 10 := 0;

begin
process(clk, reset)
variable vx, vy, vindex : integer;
begin
    if reset = '1' then 
        state <= IDLE;
        bombs <= (others => '0');
        bomb_count <= 0;
        done <= '0';
    
    elsif rising_edge(clk) then
        case state is
            when IDLE => 
--                done <= '0'; 
--                if reset = '0' then
--                    bombs <= (others => '0');
--                    bomb_count <= 0;
                    state <= GENERATED;
                --end if;
            when GENERATED =>
                if bomb_count < 10 then
                    vy := conv_integer(rng_in(2 downto 0));
                    vx := conv_integer(rng_in(5 downto 3));
                    
                    vindex := vx * 8 + vy;
                    
                    if bombs(vindex) = '0' then
                        bombs(vindex) <= '1';
                        bomb_count <= bomb_count + 1;
                    end if;
                else state <= FINISH;
                end if;
            when FINISH =>
               done <= '1';
               state <= FINISH;
        end case;
    end if;
end process;
bombs_flat <= bombs;
end Behavioral;
