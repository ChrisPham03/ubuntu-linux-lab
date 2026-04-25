.PHONY: help build up shell down status rebuild reset clean logs

# Default target
help:
	@echo ""
	@echo "  Ubuntu Linux Lab - available commands:"
	@echo ""
	@echo "    make build     Build the lab image (first-time setup)"
	@echo "    make up        Start the lab container"
	@echo "    make shell     Enter the lab (opens zsh)"
	@echo "    make down      Stop the container"
	@echo "    make status    Show container status"
	@echo "    make rebuild   Rebuild image from scratch (no cache)"
	@echo "    make reset     Full reset: destroy + rebuild + start"
	@echo "    make clean     Remove container and volumes (data loss!)"
	@echo "    make logs      Tail container logs"
	@echo ""

build:
	docker compose build

up:
	docker compose up -d
	@echo "Lab is up. Run 'make shell' to enter."

shell:
	@docker compose exec ubuntu-learn zsh || \
	  (echo "Container not running. Starting it..." && \
	   docker compose up -d && docker compose exec ubuntu-learn zsh)

down:
	docker compose down

status:
	@docker compose ps

rebuild:
	docker compose build --no-cache

reset:
	docker compose down -v
	docker compose build --no-cache
	docker compose up -d
	@echo "Lab has been reset. Run 'make shell' to enter."

clean:
	docker compose down -v
	@echo "Container and volumes removed."

logs:
	docker compose logs -f
