local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
end

return require('packer').startup({
    function(use)
        use 'wbthomason/packer.nvim'

        use {
            'doums/darcula',
            config = function()
                vim.cmd[[colorscheme darcula]]
            end
        }
        
        use { 
            'feline-nvim/feline.nvim',
            requires = 'kyazdani42/nvim-web-devicons',
            config = function()
                require('feline').setup()
                require('feline').winbar.setup()
            end
        }

        use {
          'lewis6991/gitsigns.nvim',
          config = function()
            require('gitsigns').setup {
                signs = {
                    add          = { hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
                    change       = { hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
                    delete       = { hl = 'GitSignsDelete', text = '', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
                    topdelete    = { hl = 'GitSignsDelete', text = '', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
                    changedelete = { hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
                    untracked    = { hl = 'GitSignsAdd'   , text = '┆', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
                }
            }
          end
        }

        if packer_bootstrap then
            require('packer').sync()
        end

    end,
    config = {
        display = {
            open_fn = function()
                return require('packer.util').float({ border = 'single' })
            end
        }
    }
})
