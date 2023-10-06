all:
	@if [ ! -d "/home/jonascim/data/mysql" ]; then \
		mkdir -p /home/jonascim/data/mysql; \
	fi
	@if [ ! -d "/home/jonascim/data/html" ]; then \
		mkdir -p /home/jonascim/data/html; \
	fi
	docker-compose -f ./srcs/docker-compose.yml up -d

down:
	docker-compose -f  ./srcs/docker-compose.yml down

clean:
	docker-compose -f ./srcs/docker-compose.yml down --rmi all -v

fclean: clean
	@if [ -d "/home/jonascim/data" ]; then \
	rm -rf /home/jonascim/data/* && \
	echo "successfully removed all contents from /home/jonascim/data"; \
	fi;

prune:
	docker system prune --all --force --volumes

re: fclean all

info:
		@echo "=============================== IMAGES ==============================="
		@docker images
		@echo
		@echo "============================= CONTAINERS ============================="
		@docker ps -a
		@echo
		@echo "=============== NETWORKS ==============="
		@docker network ls
		@echo
		@echo "====== VOLUMES ======"
		@docker volume ls