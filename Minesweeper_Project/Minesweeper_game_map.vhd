----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2026 12:20:46
-- Design Name: 
-- Module Name: Minesweeper_game_map - Behavioral
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

package bombs_integer is
    type bomb_array is array (0 to 63) of integer range 0 to 9;
end package bombs_integer;

library IEEE;
use IEEE.std_logic_1164.ALL;
use work.bombs_integer.all;
use IEEE.std_logic_unsigned.all;

entity Minesweeper_game_map is
    Port ( start : in STD_LOGIC;
           clk : in STD_LOGIC;
           bombs_flat : in STD_LOGIC_VECTOR (63 downto 0);
           map_mines: out bomb_array := (others => 0));
end Minesweeper_game_map;

architecture Behavioral of Minesweeper_game_map is

begin

process(clk)
variable vsum : integer;
begin
    if rising_edge(clk) then
        if start = '1' then
            for i in 0 to 7 loop
                for j in 0 to 7 loop
                    vsum:= 0;
                if bombs_flat(i * 8 + j) = '0' then
                    --corners_start
                    --top_left
                    if i = 0 and j = 0 then
                        if bombs_flat(1) = '1' then
                            vsum := vsum + 1;
                        end if;
                        
                        if bombs_flat(9) = '1' then
                            vsum := vsum + 1;
                        end if;
                        
                        if bombs_flat(8) = '1' then
                             vsum := vsum + 1;
                        end if;
                    end if;
                    
                    --top_right
                    if i = 0 and j = 7 then
                        if bombs_flat(6) = '1' then
                            vsum := vsum + 1;
                        end if;
                        
                        if bombs_flat(14) = '1' then
                            vsum  := vsum + 1;
                        end if;
                        
                        if bombs_flat(15) = '1' then
                            vsum := vsum + 1;
                        end if;
                    end if;
                    
                    --bottom_left
                    if i = 7 and j = 0 then
                        if bombs_flat(48) = '1' then
                            vsum := vsum + 1;
                        end if;
                        
                        if bombs_flat(49) = '1' then
                            vsum  := vsum + 1;
                        end if;
                        
                        if bombs_flat(57) = '1' then
                            vsum := vsum + 1;
                        end if;
                    end if;
                    
                    --bottom_right
                    if i = 7 and j = 7 then
                        if bombs_flat(62) = '1' then
                            vsum := vsum + 1;
                        end if;
                        
                        if bombs_flat(54) = '1' then
                            vsum  := vsum + 1;
                        end if;
                        
                        if bombs_flat(55) = '1' then
                            vsum := vsum + 1;
                        end if;
                    end if;
                    --corners_end
                    
                    --top_edge
                    if i = 0 and j > 0 and j < 7 then
                            if bombs_flat(i*8 + j-1) = '1' then
                                vsum := vsum + 1;
                            end if;
                            if bombs_flat((i+1)*8 + j-1) = '1' then
                                vsum := vsum + 1;
                            end if;
                            
                            if bombs_flat((i+1)*8 + j) = '1' then
                                vsum := vsum + 1;
                            end if;
                            
                            if bombs_flat(i*8 + j+1) = '1' then
                                vsum := vsum + 1;
                            end if;
                            if bombs_flat((i+1)*8 + j+1) = '1' then
                                vsum := vsum + 1;
                            end if;
                    end if;
                    
                    --bottom_edge
                    if i = 7 and j > 0 and j < 7 then
                            if bombs_flat(i*8 + j-1) = '1' then
                                vsum := vsum + 1;
                            end if;
                            if bombs_flat((i-1)*8 + j-1) = '1' then
                                vsum := vsum + 1;
                            end if;
                            
                            if bombs_flat((i-1)*8 + j) = '1' then
                                vsum := vsum + 1;
                            end if;
                            
                            if bombs_flat(i*8 + j+1) = '1' then
                                vsum := vsum + 1;
                            end if;
                            if bombs_flat((i-1)*8 + j+1) = '1' then
                                vsum := vsum + 1;
                            end if;
                    end if;
                    
                    --left_edge
                    if j = 0 and i > 0 and i < 7 then
                            if bombs_flat((i-1)*8 + j+1) = '1' then
                                vsum := vsum + 1;
                            end if;
                            if bombs_flat(i*8 + j+1) = '1' then
                                vsum := vsum + 1;
                            end if;
                            if bombs_flat((i+1)*8 + j+1) = '1' then
                                vsum := vsum + 1;
                            end if;
                        
                            if bombs_flat((i-1)*8 + j) = '1' then
                                vsum := vsum + 1;
                            end if;
                            
                            if bombs_flat((i+1)*8 + j) = '1' then
                                vsum := vsum + 1;
                            end if;
                    end if;
                    
                    --right_edge
                    if j = 7 and i > 0 and i < 7 then
                            if bombs_flat((i-1)*8 + j-1) = '1' then
                                vsum := vsum + 1;
                            end if;
                            if bombs_flat(i*8 + j-1) = '1' then
                                vsum := vsum + 1;
                            end if;
                            if bombs_flat((i+1)*8 + j-1) = '1' then
                                vsum := vsum + 1;
                            end if;
                        
                            if bombs_flat((i-1)*8 + j) = '1' then
                                vsum := vsum + 1;
                            end if;
                            
                            if bombs_flat((i+1)*8 + j) = '1' then
                                vsum := vsum + 1;
                            end if;
                    end if;
                    
                    --middle_part_start
                    if i > 0 and j > 0 then
                        if i < 7 and j < 7 then
                            if bombs_flat((i-1)*8 + j-1) = '1' then
                                vsum := vsum + 1;
                            end if;
                            
                            if bombs_flat(i*8 + j-1) = '1' then
                                vsum := vsum + 1;
                            end if;
                            if bombs_flat((i+1)*8 + j-1) = '1' then
                                vsum := vsum + 1;
                            end if;
                            
                            if bombs_flat((i-1)*8 + j) = '1' then
                                vsum := vsum + 1;
                            end if;
                            if bombs_flat((i+1)*8 + j) = '1' then
                                vsum := vsum + 1;
                            end if;
                            
                            if bombs_flat((i-1)*8 + j+1) = '1' then
                                vsum := vsum + 1;
                            end if;
                            if bombs_flat(i*8 + j+1) = '1' then
                                vsum := vsum + 1;
                            end if;
                            if bombs_flat((i+1)*8 + j+1) = '1' then
                                vsum := vsum + 1;
                            end if;
                        end if;
                    end if;
                    else vsum := 9;
                    end if;
                    map_mines(i*8 + j) <= vsum;
                end loop;
            end loop;
        end if;
    end if;
end process;

end Behavioral;
