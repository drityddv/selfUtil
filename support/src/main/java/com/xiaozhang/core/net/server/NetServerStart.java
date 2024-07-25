package com.xiaozhang.core.net.server;

import com.xiaozhang.core.net.message.pb.*;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.*;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.codec.protobuf.ProtobufDecoder;
import io.netty.handler.codec.protobuf.ProtobufEncoder;
import io.netty.handler.logging.LogLevel;
import io.netty.handler.logging.LoggingHandler;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class NetServerStart {

    public static void main(String[] args) {
        try {
            new NetServerStart().start();
        } catch (InterruptedException e) {
            log.error("start error", e);
        }
    }

    public void start() throws InterruptedException {
        EventLoopGroup bossGroup = new NioEventLoopGroup(1);
        EventLoopGroup workerGroup = new NioEventLoopGroup();
        try {
            ServerBootstrap b = new ServerBootstrap();
            b.group(bossGroup, workerGroup).channel(NioServerSocketChannel.class)
                .handler(new LoggingHandler(LogLevel.INFO)).childHandler(new ChannelInitializer<Channel>() {
                    @Override
                    protected void initChannel(Channel ch) throws Exception {
                        ChannelPipeline p = ch.pipeline();
                        p.addLast(new ProtocolBufPacketDecoder());
                        p.addLast(new ProtocolBufPacketEncoder());
                        p.addLast(new SimpleChannelInboundHandler<ProtocolBufPacket>() {
                            @Override
                            protected void messageReceived(ChannelHandlerContext ctx, ProtocolBufPacket msg) throws Exception {
                                
                            }
                        });
                    }
                });

            ChannelFuture f = b.bind(10000).sync();
            f.channel().closeFuture().sync();
        } finally {
            bossGroup.shutdownGracefully();
            workerGroup.shutdownGracefully();
        }
    }

}
