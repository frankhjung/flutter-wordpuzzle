# Use prebuilt web assets from the build context (if present)
FROM nginx:alpine AS prebuilt
COPY build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# Builder (non-root): runs flutter as a non-privileged user to avoid root warnings.
FROM instrumentisto/flutter AS builder

ARG USER_ID=1000
ARG GROUP_ID=1000
ENV HOME=/home/appuser

# Create group and user. Use existing group if GROUP_ID 1000 already exists.
RUN if ! getent group ${GROUP_ID} > /dev/null; then \
        groupadd -g ${GROUP_ID} appgroup; \
    fi && \
    if ! getent passwd ${USER_ID} > /dev/null; then \
        useradd -m -u ${USER_ID} -g ${GROUP_ID} -s /bin/bash appuser; \
    else \
        # If user exists, ensure they have a home directory and it's owned by them
        mkdir -p ${HOME} && chown ${USER_ID}:${GROUP_ID} ${HOME}; \
    fi

WORKDIR /app
COPY . .

# Ensure the appuser owns the /app directory
RUN chown -R ${USER_ID}:${GROUP_ID} /app

USER ${USER_ID}
RUN flutter pub get
RUN flutter build web --release

# Final stage: serve the built app with nginx
FROM nginx:alpine AS final
# Copy from the non-root builder.
COPY --from=builder /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
