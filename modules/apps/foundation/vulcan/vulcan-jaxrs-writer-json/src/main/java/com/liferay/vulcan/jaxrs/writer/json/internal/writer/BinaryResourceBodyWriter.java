/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.vulcan.jaxrs.writer.json.internal.writer;

import com.liferay.vulcan.result.Try;
import com.liferay.vulcan.wiring.osgi.util.GenericUtil;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import java.lang.annotation.Annotation;
import java.lang.reflect.Type;

import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.ext.MessageBodyWriter;
import javax.ws.rs.ext.Provider;

import org.osgi.service.component.annotations.Component;

/**
 * Gives Vulcan the ability to write input stream as binary output streams
 *
 * @author Javier Gamarra
 *
 * @review
 */
@Component(
	immediate = true, property = "liferay.vulcan.message.body.writer=true"
)
@Provider
public class BinaryResourceBodyWriter
	implements MessageBodyWriter<Try.Success<InputStream>> {

	public long getSize(
		Try.Success<InputStream> singleModelSuccess, Class<?> aClass, Type type,
		Annotation[] annotations, MediaType mediaType) {

		return -1;
	}

	public boolean isWriteable(
		Class<?> aClass, Type genericType, Annotation[] annotations,
		MediaType mediaType) {

		Try<Class<Object>> classTry = GenericUtil.getGenericClassTry(
			genericType, Try.class);

		return classTry.filter(
			InputStream.class::equals
		).isSuccess();
	}

	@Override
	public void writeTo(
			Try.Success<InputStream> success, Class<?> aClass, Type type,
			Annotation[] annotations, MediaType mediaType,
			MultivaluedMap<String, Object> multivaluedMap,
			OutputStream outputStream)
		throws IOException, WebApplicationException {

		InputStream inputStream = success.getValue();

		byte[] bytes = new byte[_DEFAULT_INITIAL_BUFFER_SIZE];

		int value = -1;

		while ((value = inputStream.read(bytes)) != -1) {
			outputStream.write(bytes, 0, value);
		}

		outputStream.close();
	}

	private static final int _DEFAULT_INITIAL_BUFFER_SIZE = 1024;

}