# Étape 1 : Builder (pour installer les dépendances PHP)
FROM composer:latest as builder
WORKDIR /app
COPY . .
# Installer les dépendances, sans les dev pour l'image finale
RUN composer install --no-dev --optimize-autoloader

# Étape 2 : Production (image légère)
FROM php:8.3-fpm-alpine
WORKDIR /var/www/html
# Installer les dépendances système nécessaires
RUN apk add --no-cache \
    nginx \
    supervisor \
    # ... autres extensions PHP nécessaires (ex: pdo, mysqli, etc.)
    && docker-php-ext-install pdo pdo_mysql opcache

# Copier l'application depuis l'étape builder
COPY --from=builder /app /var/www/html

# Configurer Nginx (vous aurez besoin d'un fichier de conf Nginx)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exposer le port et démarrer les services (simplifié pour l'exemple)
EXPOSE 9000
CMD ["php", "artisan", "serve", "--host", "0.0.0.0", "--port", "9000"]