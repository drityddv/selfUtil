package com.xiaozhang.core.net.message.pb;

import java.util.List;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.*;

/**
 * @author : xiaozhang
 * @since : 2024/7/8 15:10
 */

public class ProtocolBufPacketEncoder extends MessageToByteEncoder<ProtocolBufPacket> {
    
    @Override
    protected void encode(ChannelHandlerContext ctx, ProtocolBufPacket msg, ByteBuf out) throws Exception {
        
    }
}
