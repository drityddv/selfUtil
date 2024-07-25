package com.xiaozhang.core.net.message.pb;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.*;

import java.util.List;

/**
 * @author : xiaozhang
 * @since : 2024/7/8 15:10
 */

public class ProtocolBufPacketDecoder extends ByteToMessageDecoder {

    @Override
    protected void decode(ChannelHandlerContext ctx, ByteBuf in, List<Object> out) throws Exception {
        int readableBytes = in.readableBytes();
        if (readableBytes < 4) {
            return;
        }
        
        int length = in.readInt();
        if(readableBytes < length) {
            in.resetReaderIndex();
            return;
        }
        
        byte[] bytes = new byte[length];
        in.readBytes(bytes);

    }
}
