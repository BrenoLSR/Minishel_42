# ==============================================================================
#                               CONFIGURAÇÕES
# ==============================================================================

NAME        = minishell
TITLE       = minishell

# Caminhos (Paths)
LIBFT_PATH  = libft
LIBFT       = $(LIBFT_PATH)/libft.a
OBJS_DIR    = objs
SRCS_DIR    = srcs

# Compilador e Flags (Bandeiras de Compilação)
CC          = cc
# -Wall -Wextra -Werror: Padrão da 42 para código rigoroso
# -I: Indica onde estão os arquivos de cabeçalho (.h)
# -g3: Adiciona informações extras para depuração (útil para o GDB/Valgrind)
CFLAGS      = -Wall -Wextra -Werror -I$(LIBFT_PATH) -Iincludes -g3

# Flags de Linkagem
# -L: Onde procurar bibliotecas (.a)
# -lft: Linka a libft
# -lreadline: Linka a biblioteca que lê os comandos do usuário no terminal
LIBFT_FLAGS = -L$(LIBFT_PATH) -lft -lreadline

# Comando para remover arquivos/diretórios (Recursive Force)
RM          = rm -rf

# ==============================================================================
#                            SELEÇÃO DE ARQUIVOS
# ==============================================================================

# Busca automaticamente todos os arquivos .c dentro da pasta srcs e subpastas
# Isso evita que você tenha que adicionar um por um manualmente
SRC         = $(shell find $(SRCS_DIR) -name "*.c")

# Transforma a lista de arquivos .c em uma lista de arquivos .o (objetos)
# E coloca eles dentro da pasta OBJS_DIR preservando a estrutura de pastas
OBJ         = $(SRC:$(SRCS_DIR)/%.c=$(OBJS_DIR)/%.o)

# Cores para deixar o terminal mais amigável
GREEN       = \033[0;32m
RED         = \033[0;31m
RESET       = \033[0m

# ==============================================================================
#                                  REGRAS
# ==============================================================================

# Regra principal (a primeira que o make executa por padrão)
all: $(NAME)

# Regra para criar o executável final
# Depende da LIBFT e de todos os arquivos OBJ
$(NAME): $(LIBFT) $(OBJ)
	@$(CC) $(CFLAGS) $(OBJ) $(LIBFT_FLAGS) -o $(NAME)
	@echo "$(GREEN)$(TITLE) compiled OK!$(RESET)"
	@echo "$(GREEN)LETS GO BASH BROS!$(RESET)"

# Regra para compilar cada arquivo .c individualmente em um arquivo .o
# %: funciona como um coringa (ex: srcs/parse/split.c -> objs/parse/split.o)
$(OBJS_DIR)/%.o: $(SRCS_DIR)/%.c
	@mkdir -p $(dir $@) # Cria a subpasta de destino se ela não existir
	@printf "Compiling: %-33.33s\r" $<
	@$(CC) $(CFLAGS) -c $< -o $@

# Regra para compilar a biblioteca Libft chamando o Makefile dela
$(LIBFT):
	@make -C $(LIBFT_PATH) --no-print-directory

# Limpa apenas os arquivos objetos (.o)
clean:
	@$(RM) $(OBJS_DIR)
	@make -C $(LIBFT_PATH) clean --no-print-directory
	@echo "$(RED)Objects removed!$(RESET)"

# Limpa os objetos e o executável (Limpeza total)
fclean: clean
	@$(RM) $(NAME)
	@make -C $(LIBFT_PATH) fclean --no-print-directory
	@echo "$(RED)$(NAME) removed!$(RESET)"

# Recompila tudo do zero (fclean + all)
re: fclean all

# Atalho para compilar e rodar o minishell imediatamente
run: all
	@./$(NAME)

# Atalho para rodar com o Valgrind para caçar leaks de memória na sua Árvore
val: all
	@valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./$(NAME)

# .PHONY avisa o Makefile que estas palavras não são nomes de arquivos, mas comandos
.PHONY: all clean fclean re run val
