FROM public.ecr.aws/prima/rust:1.80.0 AS build

WORKDIR /code

# Needed to have the same file owner in the container and in Linux host

RUN rustup target add wasm32-unknown-unknown
RUN cargo install --locked trunk

COPY ./ ./
RUN trunk build web/index.html
RUN cargo build

FROM public.ecr.aws/prima/rust:1.80.0
WORKDIR /
COPY --from=build /code/dist /web/dist
COPY --from=build /code/target/debug/localauth0 /localauth0

ENTRYPOINT [ "/localauth0" ]
